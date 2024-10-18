#!/bin/bash

# Delete migrations and snapshots
find priv/repo/migrations -type f | xargs rm
find priv/resource_snapshots/repo -type f | xargs rm
find priv/test_repo/migrations -type f | xargs rm
find priv/resource_snapshots/test_repo -type f | xargs rm

# Regenerate migrations
mix ash.codegen --name genesis

# Run migrations if flag
if echo $* | grep -e "-m" -q; then
  mix ash.migrate
fi
