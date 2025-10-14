
// Jenkins Job DSL: Multibranch Pipeline seed
// Configure folder/name/credentials/repo and run this job once to create the multibranch item.
pipelineJob('seed-multibranch') {
  definition {
    cps {
      script("""
        node {
          stage('Create Multibranch') {
            def configXml = '''
<com.cloudbees.hudson.plugins.folder.Folder plugin="cloudbees-folder">
  <properties/>
</com.cloudbees.hudson.plugins.folder.Folder>
'''
            // ensure folder
            if (Jenkins.instance.getItem('projects') == null) {
              jenkins.model.Jenkins.instance.createProject(com.cloudbees.hudson.plugins.folder.Folder, 'projects')
            }

            def name = 'projects/90daysofdevops-mbp'
            def mbp = Jenkins.instance.getItemByFullName(name)
            if (mbp == null) {
              def p = new org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject(Jenkins.instance, name)
              Jenkins.instance.items.add(p)
              mbp = p
            }

            // Configure branch source (Git) via Groovy
            def source = new jenkins.plugins.git.GitSCMSource('https://github.com/REPLACE_ORG/REPLACE_REPO.git')
            source.credentialsId = 'REPLACE_CREDENTIALS' // or leave empty for public

            def strategy = new jenkins.branch.DefaultBranchPropertyStrategy(new jenkins.branch.BranchProperty[0])
            def branchSource = new jenkins.branch.BranchSource(source)
            branchSource.setStrategy(strategy)

            mbp.getSourcesList().clear()
            mbp.getSourcesList().add(branchSource)

            mbp.setBuildStrategies([new jenkins.branch.buildstrategies.basic.TagBuildStrategy()] as java.util.List)

            mbp.setOrphanedItemStrategy(new com.cloudbees.hudson.plugins.folder.computed.DefaultOrphanedItemStrategy(true, "", ""))
            mbp.factory = new org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory()
            mbp.factory.setScriptPath('Jenkinsfile')

            mbp.save()
            echo "Multibranch created/updated: ${name}"
          }
        }
      """.stripIndent())
      sandbox(true)
    }
  }
}
