CROSS_CHECK_RESULT=0

# "$(dirname "$0")"/check-syntax.sh
# check php/ruby/go syntax
while read FILE; do
    # check that file not removed(also can be implemented using --diff-filter)
    if [[ -f $FILE ]]; then
        if [[ "$FILE" =~ ^.+(php|html)$ ]]; then
            php -l "$FILE"
            if [[ $? -ne 0 ]]; then
                CROSS_CHECK_RESULT=1
            fi
        elif [[ "$FILE" =~ ^.+(rb)$ ]]; then
            ruby -c "$FILE"
            if [[ $? -ne 0 ]]; then
                CROSS_CHECK_RESULT=1
            fi
        elif [[ "$FILE" =~ ^.+(go)$ ]]; then
            gofmt -l -e "$FILE"
            if [[ $? -ne 0 ]]; then
                CROSS_CHECK_RESULT=1
            fi
        fi
    fi
done <<EOT
    $(git diff --cached --name-only)
EOT

if [[ $CROSS_CHECK_RESULT -ne 0 ]]; then
    echo "Aborting commit due to files with syntax errors" >&2
    exit $CROSS_CHECK_RESULT
fi
# =======================


# "$(dirname "$0")"/check-debugging-code.sh
# blackList="console.info\|console.log\|alert\|var_dump\|dsm\|dpm"
blackList="console.info\|console.log\|var_dump\|dsm\|dpm"
# CROSS_CHECK_RESULT=0
while read FILE; do
    # check that file not removed(also can be implemented using --diff-filter)
    if [[ -f $FILE ]]; then
        if [[ "$FILE" =~ ^.+(php|html|js)$ ]]; then
            RESULT=$(grep -i -m 1 "$blackList" "$FILE")
            if [[ ! -z $RESULT ]]; then
                echo "$FILE contains denied word: $RESULT"
                CROSS_CHECK_RESULT=1
            fi
        fi
fi
done << EOT
    $(git diff --cached --name-only)
EOT

if [[ $CROSS_CHECK_RESULT -ne 0 ]]; then
    echo "Aborting commit due to denied words"
    exit $CROSS_CHECK_RESULT
fi
# =======================


# "$(dirname "$0")"/check-phpcs.sh
# CROSS_CHECK_RESULT=0
PROJECT=`php -r "echo dirname(dirname(dirname(dirname(realpath('$0')))));"`
while read FILE; do
    # check that file not removed(also can be implemented using --diff-filter)
    if [[ -f $FILE ]]; then
        if [[ "$FILE" =~ ^.+(php|module|inc|install|test|profile|theme|css|info|txt|md|yml)$ ]]; then
            FILES="$FILES $PROJECT/$FILE"
        fi
fi
done << EOT
    $(git diff --cached --name-only)
EOT

if [[ "$FILES" != "" ]]; then
    echo "=== Running Code Sniffer. Code standard Drupal. ==="
    phpcs --standard=Drupal --extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml --ignore=node_modules,bower_components,vendor -p $FILES
    if [[ $? -ne 0 ]]
    then
        echo "Error detected!"
        echo "Run"
        echo "'phpcbf $FILES'"
        echo "for automatic fix or fix it manually."
        CROSS_CHECK_RESULT=1
    fi
    echo ""
    echo ""
    echo ""
    echo "=== Running Code Sniffer. Code standard DrupalPractice. ==="
    phpcs --standard=DrupalPractice --extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml --ignore=node_modules,bower_components,vendor -p $FILES
    if [[ $? -ne 0 ]]
    then
        echo "Error detected!"
        echo "Run"
        echo "'phpcbf $FILES'"
        echo "for automatic fix or fix it manually."
        CROSS_CHECK_RESULT=1
    fi
fi

if [[ $CROSS_CHECK_RESULT -ne 0 ]]; then
    echo "Fix the error before commit!"
    exit $CROSS_CHECK_RESULT
fi
# =======================


# "$(dirname "$0")"/check-eslint.sh
# CROSS_CHECK_RESULT=0
# PROJECT=`php -r "echo dirname(dirname(dirname(dirname(realpath('$0')))));"`
LINT_CONFIG="$PROJECT/.git/hooks/team-code-checker/eslintrc.json"
LINT_IGNORE="$PROJECT/.git/hooks/team-code-checker/.eslintignore"
while read FILE; do
    # check that file not removed(also can be implemented using --diff-filter)
    if [[ -f $FILE ]]; then
        if [[ "$FILE" =~ ^.+(js)$ ]]; then
            FILES="$FILES $PROJECT/$FILE"
        fi
fi
done << EOT
    $(git diff --cached --name-only)
EOT

if [[ "$FILES" != "" ]]; then
    echo ""
    echo ""
    echo "=== Running ESLint. ==="
    npx eslint -c $LINT_CONFIG --ignore-path $LINT_IGNORE $FILES
    if [[ $? -ne 0 ]]
    then
        echo "Error detected!"
        echo "Run"
        echo "'npx eslint --fix -c $LINT_CONFIG $FILES'"
        echo "for automatic fix or fix it manually."
        CROSS_CHECK_RESULT=1
    fi
fi

if [[ $CROSS_CHECK_RESULT -ne 0 ]]; then
    echo "Fix the error before commit!"
    exit $CROSS_CHECK_RESULT
fi
# =======================
