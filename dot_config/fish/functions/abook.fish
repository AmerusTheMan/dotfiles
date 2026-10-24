function abook
    # Set output filename based on the current directory name
    set output_file (basename "$PWD").m4b
    set temp_list (mktemp)
    set metadata_file (mktemp)
    set temp_mp3 (mktemp --suffix=.mp3)
    set temp_m4b (mktemp --suffix=.m4b)

    # Cleanup function
    function __abook_cleanup --on-event fish_exit
        rm -f "$temp_list" "$metadata_file" "$temp_mp3" "$temp_m4b"
    end

    # Help message
    if test "$argv[1]" = "-h" -o "$argv[1]" = "--help"
        echo "Usage: abook"
        echo "Merges all MP3 files in the current directory into a single M4B file named after the folder."
        return 0
    end

    # Remove existing output/temp files
    rm -f "$output_file" "$temp_list" "$metadata_file" "$temp_mp3" "$temp_m4b"

    # Create concat list
    function create_mp3_list
        rm -f "$temp_list"

        for file in (find . -maxdepth 1 -type f -name "*.mp3" | sort)
            if test (basename "$file") != (basename "$temp_mp3")
                echo "file '(realpath "$file")'" >> "$temp_list"
            end
        end
    end

    # Merge MP3 files
    function merge_mp3
        ffmpeg -f concat -safe 0 -i "$temp_list" -c copy "$temp_mp3"

        if not test -f "$temp_mp3"
            echo "Error: Failed to create temp.mp3"
            return 1
        end
    end

    # Convert to M4B
    function convert_to_m4b
        ffmpeg -i "$temp_mp3" -c:a aac -b:a 64k "$temp_m4b"

        if not test -f "$temp_m4b"
            echo "Error: Failed to create temp.m4b"
            return 1
        end
    end

    # Generate chapter metadata
    function generate_metadata
        echo ";FFMETADATA1" > "$metadata_file"
        echo "title="(basename "$PWD") >> "$metadata_file"
        echo "artist=Unknown" >> "$metadata_file"
        echo "album="(basename "$PWD") >> "$metadata_file"

        set index 1
        set start_time 0

        for file in (find . -maxdepth 1 -type f -name "*.mp3" | sort)
            if test (basename "$file") != (basename "$temp_mp3")

                set duration (
                    ffmpeg -i "$file" 2>&1 \
                    | grep "Duration" \
                    | awk '{print $2}' \
                    | tr -d ,
                )

                # Convert HH:MM:SS.xx to seconds
                set seconds (
                    echo "$duration" \
                    | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'
                )

                set start_ms (echo "$start_time * 1000" | bc)
                set end_ms (echo "($start_time + $seconds) * 1000" | bc)

                echo "" >> "$metadata_file"
                echo "[CHAPTER]" >> "$metadata_file"
                echo "TIMEBASE=1/1000" >> "$metadata_file"
                echo "START=$start_ms" >> "$metadata_file"
                echo "END=$end_ms" >> "$metadata_file"
                echo "title=Chapter $index" >> "$metadata_file"

                set start_time (echo "$start_time + $seconds" | bc)
                set index (math "$index + 1")
            end
        end
    end

    # Add metadata to final file
    function add_metadata
        ffmpeg -i "$temp_m4b" -i "$metadata_file" -map_metadata 1 -c copy "$output_file"
        echo "M4B file created: $output_file"
    end

    # Execute steps
    create_mp3_list
    merge_mp3; or return 1
    convert_to_m4b; or return 1
    generate_metadata
    add_metadata
end
