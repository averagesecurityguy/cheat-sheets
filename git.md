Git Cheat Sheet
===============
Basic Workflow
--------------
1. Create a new project.
2. Develop code:
  * For small code edits like adding a comment or fixing a typo, I make the changes directly on Master.
  * For features, I create a new branch for that feature and do all the work on that branch. Once a feature is complete and tested, I merge that branch back into Master.
  * While working on a particular feature, if you need to get changes from Master into your feature branch, then rebase.
3. Once your Master branch is ready for distribution, create a tag with the version number of the distribution. Then create an archive from that tag and distribute that file.
4. Continue to develop code and then tag and distribute that code.


Branches
--------
* Create: `git checkout -b <branch_name>`
* Change: `git checkout <branch_name>`
* Push: `git push -u origin <branch_name>`
* Merge: `git merge <branch_name1> <branch_name2>
* Delete: `git branch -d <branch_name>
* Update a branch with changes in master: `git checkout <branch_name>; git rebase master`


Tags
----
* Create: `git tag -a v1.4 -m "Some Message."`
* View: `git tag -n`
* Delete: `git tag -d v1.4`
* Push: `git push --tags`


Create Archive From Tag
-----------------------
* Option 1: `git archive --prefix=git-1.4.0/ -o git-1.4.0.tar.gz v1.4.0`
* Option 2: `git archive --format=tar.gz --prefix=git-1.4.0/ v1.4.0 >git-1.4.0.tar.gz`


View Commits Between Tags
-------------------------
* Commits between two tags: `git log --pretty=format:%s Tag1..Tag2`
* Commits between tag and HEAD: `git log --pretty=format:%s Tag..HEAD`
