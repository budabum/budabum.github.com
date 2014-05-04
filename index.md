---
layout: page
title: Welcome!
---
{% include JB/setup %}

## About
This is my personal site and blog.


## Blog posts
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

## FAQ
Why?
  : It looks it's time.

Why English?
  : I'd prefer to have technical posts on English. It's just simplier to write them without switching between languages.

Why Russian?
  : I'm Russian. I like Russian language and, of course, I know it much better than English.

About what this site?
  : Let's see. I do not want to have any restrictions.

Why github and jekyll?
  : I like Ruby. I like Git. I feel almighty here in opposite to having blog on some "popular platform" where I have to think how to workaround platform's drawbacks.

