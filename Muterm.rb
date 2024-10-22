# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'open3'
require 'tty-prompt'
require 'io/console'

# Creating global variables for the script
$prompt = TTY::Prompt.new
$thread = nil
$helpStr =
"""
These are some helpful flags you can give alongside the song name.
     -a Just play the audio version
     -v Play the video version
     -o List the song options found to select desired one
     -l loop the song

These are some helpful keys that you can use while the song is playing.
     S - To stop looping
     E - To exit the program
     M - Mute
     P - Pause the song
 """
 $songVolume = 65  
 $songLooping = false


"""
Function to introduce the terminal music player script to the user.
"""
def introduceScript
    puts "Welcome to terminal music player script."  
    puts "Listen to your favourite songs on the terminal"
    puts $helpStr
end # End of the introduceScript() function

"""
Function to display the song names and to choose the desired version.

@param sQuery The song name
@param givenFlags The flags given by the user
@returns The desired song version of the song name
"""
def displayAndChooseSongs(sQuery, givenFlags)
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
      end # Loop ends

      # Loop through the songs to filter the best ones
      getSongs.each_with_index do |song, index|
        songTitle = song[:title]
        # Filter song titles so that the appropriate song titles are displayed
        next if songTitle.match?(/^\w{10,}$/) || songTitle.match?(/^\w{11}$/)
        next if songTitle.include?('http') || songTitle.length < 3
        next unless songTitle.match?(/[a-zA-Z]/)

        # Display the songs if the -o flag is given
        counter += 1
        if givenFlags.include?("-o")
          puts "#{counter}. #{songTitle}"
        end # End the if block
        # Store the counter variable with song details in the hash
        songsHash[counter] = [song[:title], song[:id], song[:url]]
      end # Loop ends
      
      # Assign the desired song version to the first song in the hash if no -o flag is given
      desiredSongVersion = songsHash[1]

      # Check that the -o flag is given
      if givenFlags.include?("-o")
        # Prompt user to pick which version to play
        print "\nChoose the number to select which version to play: "
        getSongNum = gets.chomp
        songInfo = songsHash[getSongNum.to_i]

        # Assign the user chosen song version to desiredSongVersion to return it
        desiredSongVersion = songInfo
      end # End the if block
    # Let user know that errors were encountered   
    else
      puts "Detected errors while executing command: #{error}"
    end # End if-else block
    return desiredSongVersion
end # End of the displayAndChooseSongs function

"""
Function to get the user song name.

@returns userSong The song chosen by the user
@returns flags The flags chosen by the user
"""
def getUserSongName
    # Prompt user to give the song name
    print "Give the song name, artist and flags: "
    getSongName = gets.chomp

    # Split the user text into the song query and flags
    songQuery = getSongName.split.reject { |part| part.start_with?('-') }.join(' ')
    flags = getSongName.split.select { |part| part.start_with?('-') }
    userSong = displayAndChooseSongs(songQuery, flags)
    return userSong, flags
end # End the getUserSongName() function

"""
Function to implement functionality of the flags

@param givenSong The song chosen by the user
@param givenFlags The flags given by the user
"""
def flagCode(songId, givenFlags)
    # Play only the audio of the song
    if givenFlags.include?("-a") || givenFlags.empty? || givenFlags.include?("-o")
      system("yt-dlp -f bestaudio --no-playlist -o - '#{songId}' | mpv --no-video --volume=#{$songVolume} -")
    # Play only the video with the audio of the song
    elsif givenFlags.include?("-v") || givenFlags.include?("-o")
      system("yt-dlp --no-playlist -o - '#{songId}' | mpv --volume=#{$songVolume} -")
    # Exit the program safely
    else
      exit(0)
    end # End if-elsif-else block
end # End flagCode function

"""
Function to play the given song.

@param givenSong The song chosen by the user
@param givenFlags The flags given by the user
"""
def playSong(givenSong, givenFlags)
  # Construct song search id
  songId = "https://www.youtube.com/watch?v=#{givenSong[1]}"
  executeThread
  $thread.run
  if givenFlags.include?("-l")
    $songLooping = true
    while $songLooping
      flagCode(songId, givenFlags)
    end

  else
    flagCode(songId, givenFlags)
  end

end # End of the playSong function

"""
Function to execute thread
"""
def executeThread
# Initialize a thread to listen for key presses
$thread = Thread.new do
  loop do
    # Get the key that was pressed
    key = STDIN.getch

    # Check for specific key presses
    case key
    when 's'
      # Toggle looping when 'l' is pressed
      $songLooping = !$songLooping
    when 'e'
      # Exit the program when 'e' is pressed
      puts "Exiting program."
      exit(0)
      Thread.kill
    else
      # Ignore other keys
      puts "You pressed: #{key}, but it does nothing."
    end

    sleep 0.1 
  end
end
end # End the executeThread function

"""
Function to run the script.
"""
def scriptRun
  # Introduce the program to the user
  introduceScript()

  # Get the song name
  snName, snFlags = getUserSongName

  # Display to the user the chosen song
  puts "Playing #{snName[0]} with #{snFlags}"

  # Play the given song
  playSong(snName, snFlags)
end # End the scriptRun function

# Execute the thread function and the run the main program script
scriptRun
