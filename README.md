# BlogPostman

A tool to post to a github pages website. Designed to post to a blog where the day of the post, the branch is formated to look like `Scheduled(2009-04-23)`. Then if this script is run on that day, the PR will be created, merged with the master branch and the post will be published for that day.

In the future I want to make this a process that you start up and it just keeps running, but for now it has to be run every day on the day of the blog post.

Currently uses GitHub API v4 to do the git management.

## Running

Just type `make` at the command-line and if everything is installed properly, it will pubish your banch to the website.
