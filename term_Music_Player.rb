# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'net/http'


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
Function to get the user song name
"""
def getUserSongName()
    # Prompt user to give the song name
    print "Give the song name, artist and flags: "
    getSongName = gets.chomp
    # Split the user text into the song query and flags
    query = getSongName.split.reject { |part| part.start_with?('-') }.join(' ')
    flags = getSongName.split.select { |part| part.start_with?('-') }
    puts "Query: #{query}"
    puts "Flags: #{flags.join(', ')}"

end

introduceScript()
getUserSongName()
