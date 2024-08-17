# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

"""
Function to prompt user to input song name

@returns songName The name of the song with the artist
"""
def promptInput()
   print "Please give the name of the song and artist: "
   songName = gets.chomp
   return songName
end

sName = promptInput()
puts "THe song name is: #{sName}"