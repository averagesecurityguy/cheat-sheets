Git Cheat Sheet
===============
Basic Workflow
--------------
1. Create a new project.
2. Develop code:
  * For small code edits like adding a comment or fixing a typo, I make the changes directly on Master.
  * For features, I create a new branch for that feature and do all the work on that branch.
    * After creating the branch, I add the branch to the upstream server.
    * While developing on the branch I make sure that I am making regular commits and pushing the changes to the upstream server.
    * Once a feature is complete and tested, I merge that branch back into Master and delete the branch.
  * While working on a particular feature, if you need to get changes from Master into your feature branch, then rebase.
3. Once your Master branch is ready for distribution, create a tag with the version number of the distribution. Then create an archive from that tag and distribute that file.
4. Continue to develop code and then tag and distribute that code.


Branches
--------
* Create a new branch: `git checkout -b <branch_name>`
* Move to a branch: `git checkout <branch_name>`
* Add a branch to upstream server: `git push --set-upstream origin <branch_name>`
* Push a branch: `git push -u origin <branch_name>`
* Merge two branches: `git merge <branch_name1> <branch_name2>`
* Delete a branch: `git branch -d <branch_name>`
* Update a branch with changes in master (Rebase): `git checkout <branch_name>; git rebase master`


Tags
----
* Create a new tag for version 1.4.0: `git tag -a v1.4.0 -m "Some Message."`
* View all tags: `git tag -n`
* Delete the tag for version 1.4.0: `git tag -d v1.4.0`
* Push the tags: `git push --tags`


Create Archive From Tag
-----------------------
* Create an archive for version 1.4.0 (Option 1): `git archive --prefix=<project_name>-1.4.0/ -o <project_name>-1.4.0.tar.gz v1.4.0`
* Create an archive for version 1.4.0 (Option 2): `git archive --format=tar.gz --prefix=<project_name>-1.4.0/ v1.4.0 > <project_name>-1.4.0.tar.gz`


View Commits Between Tags
-------------------------
* Commits between two tags: `git log --pretty=format:%s Tag1..Tag2`
* Commits between tag and HEAD: `git log --pretty=format:%s Tag..HEAD`
