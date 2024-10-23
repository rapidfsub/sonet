#!/bin/bash

repo=$1

# Delete migrations and snapshots
if [ -z "$repo" ]; then
  find priv/repo/migrations/2*.exs -type f | xargs rm
  find priv/resource_snapshots/repo -type f | xargs rm
  find priv/test_repo/migrations/2*.exs -type f | xargs rm
  find priv/resource_snapshots/test_repo -type f | xargs rm
else
  find priv/$repo/migrations/2*.exs -type f | xargs rm
  find priv/resource_snapshots/$repo -type f | xargs rm
fi

# Regenerate migrations
mix ash.codegen --name genesis

# Run migrations if flag
if echo $* | grep -e "-m" -q; then
  mix ash.migrate
fi
