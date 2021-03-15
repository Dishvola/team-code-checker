# team-code-checker
Checking your code on the "git pre-commit hook" by running PHP Code Sniffer and ESLint.

Using by our team for work with Drupal 7/8/9 PHP/JS code standards.

https://www.drupal.org/docs/develop/standards/coding-standards

https://www.drupal.org/docs/develop/standards/javascript/javascript-coding-standards

# Instructions

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
	__You should do it once for your system!__
	Coder using for check code in the Drupal 7 and 8/9.
	Those checks apply to all versions of Drupal, so you can use Coder (for example 8.3.x) to check Drupal 7 code.
	So you should do only this sections and please double-check __Verify Registered Standards__ step.
	- Install Coder and PHPCS with Composer
	    - Global Coder Install
	    
	        - `composer global require drupal/coder`

		    - (You can skip this step if your $PATH variable contain path to the Composer dir.) `export PATH="$PATH:$HOME/.composer/vendor/bin"`

	    - Register Coder Standards
	        - Composer Installer Plugin
	        
		        `composer global require dealerdirect/phpcodesniffer-composer-installer`

		    - Manually Set Installed Paths
                `phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer`

		    - __Verify Registered Standards__
		    
			    `phpcs -i` - Result like - "The installed coding standards are PEAR, Zend, PSR2, MySource, Squiz, PSR1, PSR12, Drupal and DrupalPractice".

3) NOTE! You can use option `-n` for skip code checking step. Example `git commit -n -m "Commit message"`. Use it only for deploy vendor libraries, contrib moduels or updated generated features code. __Keep in mind, all your custom code shoud be checked!!!__

4) Now you can do your work much better! Please try add some code with error to the php or js file for example and then create commit.

# Examples for fix old code.

1) JS

    - warning - Unexpected unnamed function - func-names

        - you can add func name like `function funcName() {` (Recommended when `this` used in the function logic) OR replace `function() {` with `() => {` for cases without `this`.

    - error - Unexpected use of 'history' - no-restricted-globals

        - you can replace `history.foo` with `window.history.foo` for most cases.

2) PHP

    - for comment code fragment

        - you can use comment format like this one (80 characters per line):

            ```php
            <?php
            // Update field_ora_additional_contrib.
            /*
            if (isset($lif['field_ora_additional_contrib'][LANGUAGE_NONE][0]
            ['value']['#value'])) {
            $lif['field_ora_additional_contrib'][LANGUAGE_NONE][0]
            ['value']['#value'] = 500;
            $commands[] = ajax_command_replace
            (".field-name-field-ora-additional-contrib.form-wrapper",
            drupal_render($lif['field_ora_additional_contrib']));
            }*/
            ```

3) Ignore options

- Ignore all the sniffs for the file:

	```php
	<?php
	// phpcs:ignoreFile
	```

- Ignore only the current and next line:

	```php
	<?php
	// phpcs:ignore
	public function store($myArray)
	```

- Ignore the current line:

	```php
	<?php
	public function store($myArray) // phpcs:ignore
	```

- Ignore a certain amount of lines in a file:

	```php
	<?php
	// phpcs:disable
	public function store($myArray): void {
	  if (count($myArray) > 3) {
	    // Humongous amount of legacy code you don't want to look at
	  }
	  
	  return;
	}
	// phpcs:enable
	```

# How it looks?

1) PHPCS

	- PHP errors and warnings: ![Image 2021-03-05 at 3 36 15 PM](https://user-images.githubusercontent.com/1149440/110924806-26a34a00-832b-11eb-9962-2b73b6912d83.jpg)

	- Generated command for autofix! ![Image 2021-03-11 at 11 29 47 AM](https://user-images.githubusercontent.com/1149440/110924830-2d31c180-832b-11eb-912a-f29950f0142a.jpg)

2) ESLint

	- JS errors and warnings: ![Image 2021-03-12 at 12 10 57 PM](https://user-images.githubusercontent.com/1149440/110925915-71719180-832c-11eb-9681-d35e573768bc.jpg)

	- Generated command for autofix!![Image 2021-03-12 at 12 12 36 PM](https://user-images.githubusercontent.com/1149440/110925907-6f0f3780-832c-11eb-8fda-fd06d4130a58.jpg)
