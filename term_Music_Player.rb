# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'open3'

$helpStr =
"""
These are some helpful flags you can give alongside the song name.
     -a Just play the audio version
     -v Play the video version 
     -l Loop
     -help flag to bring up this menu again
 """

"""
Function to introduce the terminal music player script to the user
"""
def introduceScript()
    puts "Welcome to terminal music player script."
    puts "Listen to your favourite songs on the terminal"
    puts $helpStr
end 

"""
Function to display the song names

@param sQuery The song name
"""
def displaySongs(sQuery)
    counter = 0
    # Contruct the song search command
    searchSong = "yt-dlp 'ytsearch10:#{sQuery}' --get-title --get-id --get-url"
    
    # Check whether the search command executed or not
    songResults, error, status = Open3.capture3(searchSong)
    if status.success?
      songResults = songResults.split("\n")
     
      # Display the songs
      getSongs = songResults.each_slice(3).map do |sTitle, sId, sUrl|
        { title: sTitle, url: sUrl }
      end
      getSongs.each_with_index do |song, index|
        # If title starts with http, go to the next one
        next if song[:title].include?('http')
        # Display the songs
        counter += 1
        puts "#{counter}. #{song[:title]}"
      end
    # Let user know that errors were encountered   
    else
      puts "Detected errors while executing command: #{error}"
    end
    
end

"""
Function to get the user song name
"""
def getUserSongName()
    # Prompt user to give the song name
    print "Give the song name, artist and flags: "
    getSongName = gets.chomp
    # Split the user text into the song query and flags
    songQuery = getSongName.split.reject { |part| part.start_with?('-') }.join(' ')
    flags = getSongName.split.select { |part| part.start_with?('-') }
    displaySongs(songQuery)

end

introduceScript()
getUserSongName()
