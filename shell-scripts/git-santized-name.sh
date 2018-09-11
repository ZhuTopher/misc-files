#! /bin/bash

proj=$(git show --quiet --format="%aN" $(git rev-parse --short HEAD))
proj=${proj//_/ }
proj=${proj// /-}
proj=${proj//[^a-zA-Z0-9-]/}
proj=$(echo -n $proj | tr '[:upper:]' '[:lower:]')

echo "$proj"

