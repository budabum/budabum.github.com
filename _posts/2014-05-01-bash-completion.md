---
layout: post
title: "bash completion"
description: ""
category: technical
tags: [bash, en]
---
{% include JB/setup %}

## Intro
A lot of time I spend in linux comand line. Sometimes I write small scripts which help me in my
 regular work. Often the scripts use set of the commands and parameters. I do not remember them all.
 I've to look at the source to refresh it in my memory and every time I wish I had completion for
 my script.
 
Now I know how! This article is not comprehanive tutorial. It just allows you to start work with
 bash completion and unfolds two ways how you can use it.

As a case study let's use the following simple program. 
{% highlight text %}
Usage:
  testwar.sh <commnad>

Example:  
  testwar.sh download	# Downloads latest build from CI
  testwar.sh deploy	# Deploys test.war and starts server
  testwar.sh start	# Starts test server
  testwar.sh stop	# Stops test server
{% endhighlight %}

And I want to use bash completion for this program.

## Completion info in the same file
Look at the following script. It contains both

- bash completion function which is part of the same script
- emulation of working code (real functions' body replaced with echo '...')

<div class='btn-inverse'><table width='100%'><tr>
<td style='text-align:left'>Completion in the same script file</td>
<th style='text-align:right'><a href='{{site.github_includes_url}}files/bash/completion/testwar.sh'>
  download: testwar.sh</a></th>
</tr></table></div>
{% highlight bash linenos %}
{% include files/bash/completion/testwar.sh title='testwar.sh' %}
{% endhighlight %}

The main interest is the function `show_completion()` which do all the completion job. This function
 is activated when `SHOW_COMPLETION` environment variable is set and not empty. You can see last
 line in code which switches between returning completion info and normal program flow.

The script uses functions which declared with keyword `function` as commands. So, method
 `get_functions` returns all known commands. This information is used both in auto-completion and
 in script as well to check whether the command provided by user is known one. When you type program
 name and then press <span class='btn-inverse btn-small'>TAB</span> you see
 
    >./testwar.sh
    deploy   download   FROM_SAME_FILE   start   stop

As you can see a const *FROM_SAME_FILE* is added to the list of the completion words. It's done to
 distinguish this example from the second one where bash completion is done with help of the shell
 function, not the command.

To add completion to the current shell session use the command:
{% highlight bash %}
complete -C 'SHOW_COMPLETION=true ./testwar.sh' testwar.sh
{% endhighlight %}

## Completion info in individual file
The following code example behaves similar to previous one. The two major differences are

- completion info is in separate file
- it's more common way when `COMPREPLY` and `COMP_WORDS` shell variables are used.


<div class='btn-inverse'><table width='100%'><tr>
<td style='text-align:left'>Individual completion file</td>
<th style='text-align:right'><a href='{{site.github_includes_url}}files/bash/completion/testwar-completion.bash'>download: testwar-completion.bash</a></th>
</tr></table></div>
{% highlight bash linenos %}
{% include files/bash/completion/testwar-completion.bash title='testwar-completion.bash' %}
{% endhighlight %}

To add completion to the current shell session:
{% highlight bash %}
source testwar-completion.bash 
{% endhighlight %}

## Commom hints

### To list all completion bindings
{% highlight bash %}
complete -p
{% endhighlight %}

### System-wide completion
Of course, you can place *testwar.sh* into the dir listed in your system $PATH. In such a case you
 can add ``complete -C 'SHOW_COMPLETION=true testwar.sh' testwar.sh`` 
 or ``source testwar-completion.bash`` in your ```~/.bashrc``` file.

### Filenames completion
If, for instance, you need to add filename after the command you can extend completion by predefined
 options. To add default auto-completion do
``complete -C 'SHOW_COMPLETION=true ./testwar.sh' -o default testwar.sh``

### Exit and return
Do not use `exit` command in completion function. It'll exit from current shell - I don't think it's
 what you want when pressing <span class='btn-inverse btn-small'>TAB</span>.
 Use `return $some-exit-code` instead.

### Man
Use `man bash` to learn about `complete` and `compgen` builtin functions.
 
### Links
Completion with function
: <http://stackoverflow.com/questions/10942919/customize-tab-completion-in-shell>

I guess it's enough to start to play with auto-completion. 

<div style='text-align:center; font-size:1.5em;'>-= The end =-</div>

