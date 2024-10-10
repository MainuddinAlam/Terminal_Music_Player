# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'open3'
require 'tty-prompt'

$prompt = TTY::Prompt.new

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
Function to display the song names and to choose the desired version

@param sQuery The song name
@returns The desired song version of the song name
"""
def displayAndChooseSongs(sQuery)
    # Initializing local variables needed for the function
    songsHash = {}
    counter = 0
    desiredSongVersion = nil
    # Contruct the song search command
    searchSong = "yt-dlp 'ytsearch10:#{sQuery}' --get-title --get-id --get-url"
    
    # Check whether the search command executed or not
    songResults, error, status = Open3.capture3(searchSong)
    if status.success?
      songResults = songResults.split("\n")
     
      # Display the songs
      getSongs = songResults.each_slice(3).map do |sTitle, sId, sUrl|
        { title: sTitle, id: sId, url: sUrl }
      end

      # Loop through the songs to filter the best ones
      getSongs.each_with_index do |song, index|
        songTitle = song[:title]
        # Filter song titles so that the appropriate song titles are displayed
        next if songTitle.match?(/^\w{10,}$/) || songTitle.match?(/^\w{11}$/)
        next if songTitle.include?('http') || songTitle.length < 3
        next unless songTitle.match?(/[a-zA-Z]/)

        # Display the songs
        counter += 1
        puts "#{counter}. #{songTitle}"
        # Store the counter variable with song details in the hash
        songsHash[counter] = [song[:title], song[:id], song[:url]]
      end

      # Prompt user to pick which version to play
      print "\nChoose the number to select which version to play: "
      getSongNum = gets.chomp
      songInfo = songsHash[getSongNum.to_i]

      # Assign the user chosen song version to desiredSongVersion to return it
      desiredSongVersion = songInfo
    # Let user know that errors were encountered   
    else
      puts "Detected errors while executing command: #{error}"
    end
    return desiredSongVersion
end

"""
Function to get the user song name

@returns userSong The song chosen by the user
@returns flags The flags chosen by the user
"""
def getUserSongName()
    # Prompt user to give the song name
    print "Give the song name, artist and flags: "
    getSongName = gets.chomp
    # Split the user text into the song query and flags
    songQuery = getSongName.split.reject { |part| part.start_with?('-') }.join(' ')
    flags = getSongName.split.select { |part| part.start_with?('-') }
    userSong = displayAndChooseSongs(songQuery)
    return userSong, flags
end

"""
Function to play the given song

@param givenSong The song chosen by the user
"""
def playSong(givenSong, givenFlags)
  # Construct song search id
  songId = "https://www.youtube.com/watch?v=#{givenSong[1]}"
  # Play only the audio of the song
  if givenFlags.include?("-a") || givenFlags.empty?
    system("yt-dlp -f bestaudio --no-playlist -o - '#{songId}' | mpv --no-video -")
   # Play only the video with the audio of the song
  elsif givenFlags.include?("-v")
    system("yt-dlp --no-playlist -o - '#{songId}' | mpv -")
  else 
    #
  end
 
end

# Introduce the program to the user
introduceScript()

# Get the song name
snName, snFlags = getUserSongName()

# DIsplay to the user the chosen song
puts "You have chosen #{snName[1]} with #{snFlags}"

# Play the given song
playSong(snName, snFlags)

