# team-code-checker
Checking your code on the "git pre-commit hook" by running PHP Code Sniffer and ESLint.

Using by our team for work with Drupal 7/8/9 code standards + check JS code.

# Istructions

1) NPM and NPX should be installed (global), then go to project root folder where dir ".git/" exist.
	- Then go to .git/hooks/ folder.
	
	    `cd /path/to/project/.git/hooks`

	- Clone repo with configurations and scripts.
	
	    `git clone git@github.com:Dishvola/team-code-checker.git`

	- Then you have two ways.
	
	    - If "pre-commit" file doesn't exist.
		    - Copy example file `cp pre-commit.sample pre-commit`
		    - Run `chmod +x pre-commit`
		    - Replace all example shell code with `"$(dirname "$0")"/team-code-checker/team-code-checker.sh` (with double quotes) for import our script.

	    - If "pre-commit" file exist.
		    - Run `chmod +x pre-commit`
		    - Add string `"$(dirname "$0")"/team-code-checker/team-code-checker.sh` (with double quotes) for import our script.
		
	- Then go to dir "team-code-checker" and run `npm i`.


2) Global Coder install via Composer. (https://www.drupal.org/node/1419988#coder)
	You should do it once for your system!
	Coder using for check code in the Drupal 7 and 8/9.
	Those checks apply to all versions of Drupal, so you can use Coder (for example 8.3.x) to check Drupal 7 code.
	So you should do only this sections.
	- Install Coder and PHPCS with Composer
	    - Global Coder Install
	    
	        - `composer global require drupal/coder`

		    - (You can skip this step if your $PATH variable contain path to the Composer dir.) `export PATH="$PATH:$HOME/.composer/vendor/bin"`

	    - Register Coder Standards
	        - Composer Installer Plugin
	        
		        `composer global require dealerdirect/phpcodesniffer-composer-installer`

		    - Manually Set Installed Paths
                `phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer`

		    - Verify Registered Standards
		    
			    `phpcs -i` - Result like - "The installed coding standards are PEAR, Zend, PSR2, MySource, Squiz, PSR1, PSR12, Drupal and DrupalPractice".

4) Now you can do your work much better! Please try add some code with error to the php or js file for example and then create commit.
