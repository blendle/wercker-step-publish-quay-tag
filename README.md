# Quay.io image publication

Using this step, you can publish a new tag, based on an existing tag in Quay.
This can be used to link a non-latest tag to latest at deploy time.

## Example

```yml
deploy:
  steps:
  - blendle/publish-quay-tag:
    token: $QUAY_API_TOKEN        # required, api token to create tag
    repository: blendle/true      # required, org/repo format
    current: $WERCKER_GIT_COMMIT  # optional, defaults to "$WERCKER_GIT_COMMIT"
    tag: other                    # optional, defaults to "latest"
    if: $ENV                      # optional, "if" should match "eq" or step is skipped
    eq: production                # optional, "eq" should match "if" or step is skipped
```

## License

The step is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
