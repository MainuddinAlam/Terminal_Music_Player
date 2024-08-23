# Ruby script to play music in the terminal
# Author: Mainuddin Alam Irteja

require 'tty-prompt'

$helpStr =
"""
These are some helpful flags you can give alongside the song name.
     -a Just play the audio
     -v Play the video
     -l Loop 

 You can use use -help flag to bring up this menu again
 """

def introduceScript()

    puts "Welcome to terminal music player script."
    puts $helpStr

end


"""
"""
def getMusic()
    prompt = TTY::Prompt.new
    search_query = prompt.ask("What music would you like to search for?")
    
    # Use the search query with yt-dlp and mpv
    system("yt-dlp -f bestaudio --extract-audio --audio-format mp3 'ytsearch:#{search_query}' -o - | mpv -")
    puts "What to do next?: "
end

introduceScript()
getMusic()
