# cloud9_cleanup_toolset

### Bash script(s) for consolidating Cloud9 VM.

#### Who?

Created mostly by Benjamin Haos with the usual help from Google Search.

### Wat?

A set of bash scripts used for working with one or more Cloud9 Virtual-Machines(VM).

#### Deletion

A simple webpage app for deleting a group of VM that follow a naming format of `<machine-name><machine-number>`. [link](https://haoscleanupcrew.github.io/cloud9_cleanup_toolset/delete_vm_series.html)

#### Archiving

A bash script useful for generating a webpage that facilitates archiving and subsuquently deleting VM. 
* View an example of the html page the script creates. [link](https://haoscleanupcrew.github.io/cloud9_cleanup_toolset/example_vm_list.html)

#### Wen?

Start date : 02/2016
Finish date : incomplete

#### Wer?

#### Why?

Created initially to deal with several hundred VM that were spun while i was doing research and studying in Korea. Initially intended as part of a capstone project, various functionality was added later.

# How?




**STATUS :** *being built/tested*

#### ToDo:

* Mod favicon.
* Add links to archive repo from prompt.
* Test.
* Delete temp file created.
* Write it up.
* ...
* Figure out if it's possible to curl the html file needed http://stackoverflow.com/questions/12399087/curl-to-access-a-page-that-requires-a-login-from-a-different-page

* make it work if there has been changes to the remote
* figure out why the index.html file gets removed occasionally.
* Display stats on the html page.
* Only update git if needed.
* Figure out if it's possible to push to the remote without downloading the repo.
   * http://unix.stackexchange.com/questions/233327/is-it-possible-to-clone-only-part-of-a-git-project
* Move the scripts functions into seperate files by action.
* Fix the logging.
   * Log which version did the Archiving.
   * Create function that logs to file whatever function is passed to it.
* Add links for deleting VM to html page.
* Seperate the gh-pages files into seperate branch?
* Fix problem with archiving repo if VM has .gt directory in project directory.
* Download repo once archive is ready vs previous.
* Try and figure out when the VM was created (script exists...)
* Number the VM on the html page.
* Set up archive so it can reload a VM.
* Seperate archive actions from VM config and setup actions.
* Create pause if another VM is being archived. (like a multi-thread handler.)

### sCrap

Cloud9 Login URL : https://c9.io/login

```
curl --user user:password --cookie-jar ./somefile https://c9.io/login
curl --cookie ./somefile https://c9.io/mediatechgender
```

#### Browser Dump

- https://github.com/HaosCarroll/z_haos_clickables
- http://www.linuxquestions.org/questions/programming-9/how-do-i-make-a-text-file-in-bash-517070/
- http://stackoverflow.com/questions/3137094/how-to-count-lines-in-a-document
- http://tldp.org/LDP/abs/html/comparison-ops.html
- http://www.w3schools.com/cssref/pr_text_color.asp
- http://stackoverflow.com/questions/15393935/boolean-in-an-if-statement
- http://www.w3schools.com/cssref/pr_class_clear.asp
- http://www.w3schools.com/cssref/tryit.asp?filename=trycss_class-clear
- http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
- http://stackoverflow.com/questions/15148796/bash-get-string-after-character
- http://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
- https://www.google.com/search?sourceid=chrome-psyapi2&ion=1&espv=2&ie=UTF-8&q=23%20*%2010&oq=23%20*%2010&aqs=chrome..69i57j69i64.16750j0j7
