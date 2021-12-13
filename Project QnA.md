# Q&A

 *  Since we are working in pairs in a team, what happens if the second team cannot start working on a user story before the previous story has been implemented by the other pair? Is there an effective way for every pair to pick what they are working on?
     ---------------> main branch
        pair A -----> branch A
             pair B   -> branch B

      0. Always sync between pairs/people to see what's missing etc and what's the best strategy
      1. Wait for A's code to be finished and merged (or work on something else that has no dependency)
      2. B can base their branch on A so they'll have the needed changes -> more complicated to manage 
        e.g branch A created from main   -> `git checkout -b branch-a`
            then branch B created A      -> `git branch branch-a ; git checkout -b branch-b`
            then you can merge back new changes from A
            but ALWAYS use a PR + code review on github to merge your branch back into main 
      3. delay implementing what needs things from the other branch

 * Having never worked with Github Issues, can we briefly touch on that?
     * issues = cards on Trello

 * When writing code, are we aiming to always be pair programming not lone working? (in a team of 5)
    - important: everyone should have something to do at any time
    - 2 pairs + 1 dev doing some work on a simpler task OR individual learning depending on personal objectives for the week
    - 1 pair + 1 "pair" of three
    - other option: pairing on more complex tickets and then doing a bit of individual work on something else 
  
  * Is it a good idea to do 2 pairs and 1 working on the HTML/CSS?
    - no more than half of the time
    - generally avoid siloing 1 dev into something specific (e.g HTML/CSS frontend)
    - it depends on what you want to focus on

  * Repo created, invited everyone as collaborators - they have to clone it (everyone on the same repo)

  * Is there any way to block collaborators from pushing and pulling directly onto the main repo (so none of us accidentally push to the main branch rather than making a branch and using pull requests)
    Yes -> settings of the repo -> branches -> branch protection rule -> require a PR on "main"

  * Merge back feature branch to main
    * `git checkout -b my-feature`
    * do a bit of work, commit
    * `git push origin my-feature` -> specify the name of the branch
    * Always use PR to merge to main
    * then you can pull main with the merge

  * Working on 2 different branches, then trying to merge the 2
    * You might run into conflicts, github won't let you merge the PR
    * In that case one the branches (`branch-a`) needs to be merged *first*
    * Then locally (for those working on branch-b)
      * pull latest main
      * while on `branch-b` -> `git merge main`
      * `git push origin branch-b`

  * Should we be creating forks of our repo for every feature?
      no forks, you're working on the same repo