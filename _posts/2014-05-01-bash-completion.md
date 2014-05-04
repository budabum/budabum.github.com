---
layout: post
title: "bash completion"
description: ""
category: technical
tags: [bash, en]
---
{% include JB/setup %}

## Intro
A lot of time I spend in linux comand line. Sometimes I write small scripts which help me in my regular work. Often the scripts use set of the commands and parameters.
This article is not comprehanive tutorial. It just allows you to start work with bash completion and unfolds two ways how you can use it.

As a case study let's use the following simple program. Program 
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

- working code
- bash completion function

<div class='btn-inverse'><table width='100%'><tr>
<td style='text-align:left'>Completion in the same script file</td>
<th style='text-align:right'><a href='{{site.github_includes_url}}files/bash/completion/testwar.sh'>download: testwar.sh</a></th>
</tr></table></div>
{% highlight bash linenos %}
{% include files/bash/completion/testwar.sh title='testwar.sh' %}
{% endhighlight %}

The main interest is the function `show_completion()` which do all the completion job. 
This function is activated when `SHOW_COMPLETION` evnironment variable is set and not empty. 
You can see last line in code which switches between returning completion info and normal program flow.
The script uses functions declared with keyword `function` as commands. So, method get functions returns all known commands.
This information is used both in autocaompletion and in script as well to check whether the command provided by user is known one.
Also, as you can see const FROM_SAME_FILE is added to list of completion words. It's done to distinguish this example from second one
 where bash completion is done with help of function, not command.

To add completion to the current shell session use the command:
{% highlight bash %}
complete -C 'SHOW_COMPLETION=true ./testwar.sh' testwar.sh
{% endhighlight %}

## Completion info in individual file
The following code example behaves siimilar to previous one. The two major differences are

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
Also, of course, you can place *testwar.sh* into the dir listed in your system $PATH. In such a case you can add ``complete -C 'SHOW_COMPLETION=true testwar.sh' testwar.sh`` 
 or ``source testwar-completion.bash`` in your ```~/.bashrc``` file.

### Filenames completion
If, for instance, you need to add filename after the command you can extend completion by predefined options. To add default auto-completion do
``complete -C 'SHOW_COMPLETION=true ./testwar.sh' -o default testwar.sh``

### Exit and return
Do not use `exit` command in completion function. It'll exit from current shell, don't think it's what do you want when pressing
 <span class='btn-inverse btn-small'>TAB</span>. Use return $exit-code instead.

### Man
Use `man bash` to learn about `complete` and `compgen` builtin functions.
 
### Links
Completion with function
: <http://stackoverflow.com/questions/10942919/customize-tab-completion-in-shell>

I guess it's enough to start to play with autocompletion. 

<div style='text-align:center; font-size:1.5em;'>-= The end =-</div>

