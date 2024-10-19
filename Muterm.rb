# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'open3'
require 'tty-prompt'
require 'tty-reader'

# Creating global variables for the script
$prompt = TTY::Prompt.new
$thread = nil
$helpStr =
"""
These are some helpful flags you can give alongside the song name.
     -a Just play the audio version
     -v Play the video version 
     -help flag to bring up this menu again

These are some helpful keys that you can use while the song is playing.
     L - To loop/unloop a song
     M - Bring up menu to play new song
 """

def executeThread()
  reader = TTY::Reader.new
  songLooping = false
  volume = 60  # Starting volume at 60%
  # Initialize a thread 
  $thread = Thread.new do
    # Continuously this loop will run
    loop do
      # Needed to check the keys are being pressed
      keysPressed = reader.read_keypress(nonblock: true)

      # Check which keys are being pressed 
      case keysPressed
    
      # Check if the key 'l' is being pressed 
      when 'l'
        # If the song is looping, stop it
        if songLooping
          songLooping = false
        # If song is not looping, loop it
        else
          songLooping = true
        end # End if-else block
      # Exit the program if user presses the key 'e'
      when 'm'
        scriptRun()
        Thread.stop
      when 'e'
        Thread.kill
        puts "You pressed: #{keysPressed}. It will exit the program."
        exit(0)
      # Just the let the user know he pressed a letter that does nothing
      else
        Thread.kill
        puts "You pressed: #{keysPressed}. It will also exit the program"
        exit(0)
    
      end
      sleep 0.1  # To reduce CPU usage
    end
  end

end # Ends the executeThread function

"""
Function to introduce the terminal music player script to the user
"""
def introduceScript()
    puts "Welcome to terminal music player script."  
    puts "Listen to your favourite songs on the terminal"
    puts $helpStr
end # End of the introduceScript() function

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
      end # Loop ends

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
      end # Loop ends

      # Prompt user to pick which version to play
      print "\nChoose the number to select which version to play: "
      getSongNum = gets.chomp
      songInfo = songsHash[getSongNum.to_i]

      # Assign the user chosen song version to desiredSongVersion to return it
      desiredSongVersion = songInfo
    # Let user know that errors were encountered   
    else
      puts "Detected errors while executing command: #{error}"
    end # End if-else block
    return desiredSongVersion
end # End of the displayAndChooseSongs function

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
end # End the getUserSongName() function


"""
Function to play the given song.

@param givenSong The song chosen by the user
@param givenFlags The flags given by the user
"""
def playSong(givenSong, givenFlags)
  # Construct song search id
  songId = "https://www.youtube.com/watch?v=#{givenSong[1]}"
  executeThread()
  $thread.run
  
  # Play only the audio of the song
  if givenFlags.include?("-a") || givenFlags.empty?
    system("yt-dlp -f bestaudio --no-playlist -o - '#{songId}' | mpv --no-video -")
  # Play only the video with the audio of the song
  elsif givenFlags.include?("-v")
    system("yt-dlp --no-playlist -o - '#{songId}' | mpv -")
  # Exit the program safely
  else
    exit(0)
  end
end # End of the playSong function

"""
Function to run the script.
"""
def scriptRun()
  $thread.kill
  # Introduce the program to the user
  introduceScript()

  # Get the song name
  snName, snFlags = getUserSongName()

  # Display to the user the chosen song
  puts "You have chosen #{snName[1]} with #{snFlags}"

  # Play the given song
  playSong(snName, snFlags)
end # End the scriptRun function

executeThread()
scriptRun()



