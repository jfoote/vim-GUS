# *G*it *U*RL *S*haring vim plugin (GUS)

GUS adds commands to vim that print the git HTTP URL for the code under the cursor and copy the URL to the clipboard if possible. 

GUS is a simple tool that helps vim users share links to code for rapid collaborative analysis via IRC/Slack/chat, wikis, and so on.

For example,

![Move cursor to interesting text](https://raw.githubusercontent.com/jfoote/vim-GUS/master/example/1.png)

![Run :GUS command](https://raw.githubusercontent.com/jfoote/vim-GUS/master/example/2.png)

![See URL](https://raw.githubusercontent.com/jfoote/vim-GUS/master/example/3.png)

![Paste in browser](https://raw.githubusercontent.com/jfoote/vim-GUS/blob/master/example/3.png)

## Installation

[pathogen.vim](https://github.com/tpope/vim-pathogen) is the recommended way to install GUS.

    cd ~/.vim/bundle
    git clone https://github.com/jfoote/vim-GUS.git

Then reload vim and try one of the GUS commands.

## Commands

### :GUS

This command prints the URL for the current line number and copies it to the clipboard if possible.

### :GUM

This command prints a markdown-formatted link for the current line number's URL and copies it to the clipboard if possible.

### :GUR

This command prints a redmine-formatted link for the current line number's URL and copies it to the clipboard if possible.

### :GUW

This command prints the location of the single-file GUS plugin implementation ([gus.vim](http://github.com/jfoote/vim-GUS/blob/master/plugin/gus.vim)) on your local filesystem to encourage hacking on it.

## How it works

### URLs

Well-known git commands are used to determine the current git repo's remote and relative file path. A simple string substitution is used to replace any `ssh://` URL schemes with `http://`. 

The URL creation logic is located in a single function, `gus#link_url`, in the single file that implements this plugin, [gus.vim](http://github.com/jfoote/vim-GUS/blob/master/plugin/gus.vim). If this hack won't work for you feel free to edit the code to suite your needs. You can use the `:GUW` command in vim to locate the plugin file on your local filesystem if you forgot where you put it.

### Copying to clipboard

GUS uses common command line utilities, such as `pbcopy` on OSX, to copy respective URL text to the clipboard. If no supported command is found, the text is printed to the vim status bar so you can copy it manually.

The clipboard logic is located in a single function, `gus#copy`, in the single file that implements this plugin, [gus.vim](http://github.com/jfoote/vim-GUS/blob/master/plugin/gus.vim). If this hack won't work for you feel free to edit the code to suit your needs. You can use the `:GUW` command in vim to locate the plugin file on your local filesystem if you forgot where you put it.

## Contributions

Please log issues in the GitHub project issue tracker and feel free to contact me at [jmfoote@loyola.edu](mailto:jmfoote@loyola.edu) if you have any questions. If you add any cool features, such as better URL scheme logic or support for additional clipboard utilities, please consider contibuting your code back via pull request.

## Other notes

GUS is simple; it should be a good starting point or template for hacking together tools for vim, git, or both. If you have any questions about these topics, or you're interested in broader topics in development, computer security, or related philosophy feel free to drop me a line at [jmfoote@loyola.edu](mailto:jmfoote@loyola.edu) or my [obligatory github.io landing page](https://jfoote.github.io). 

Something that encompasses this plugin's functionality might already exist -- if you know of something that does please [let me know](mailto:jmfoote@loyola.edu) and I'll point readers to it.

Thanks for reading all the way to the end. The world needs more developers like you.

```
Jonathan Foote
jmfoote@loyola.edu
2014 Dec 21
```

