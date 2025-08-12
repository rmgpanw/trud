# trud 0.2.0

## Major changes

* Enhanced parameter design with enum validation:
  - `get_item_metadata()` and `get_subscribed_metadata()` now use `release_scope = c("all", "latest")` parameter instead of `latest_only` boolean. This makes function calls more expressive and eliminates boolean ambiguity.
  - `download_item()` now uses `file_type = c("archive", "checksum", "signature", "publicKey")` parameter instead of `download_file`.

* Added `overwrite` parameter to `download_item()` allowing users to explicitly control whether existing files should be overwritten.

* **Breaking changes:**
  - Removed `TRUD_API_KEY` parameter from all exported functions. API keys must now be set via the `TRUD_API_KEY` environment variable only.
  - `download_item()` parameter `download_file` renamed to `file_type` with enhanced validation.
  - `get_item_metadata()` and `get_subscribed_metadata()` parameter `latest_only` replaced with `release_scope`.

## Minor changes and bug fixes

* Improved documentation and user experience:
  - Enhanced subscription workflow documentation with clear step-by-step guidance.
  - Added explanation that `purrr::map_at()` pattern is used in examples to avoid exposing API keys.
  - Clarified how to obtain and use release IDs from `get_item_metadata()` for downloading specific releases.

* Enhanced robustness and testing:
  - Added validation warnings to `trud_items()` to detect changes in NHS TRUD website structure that might break the scraper.
  - Refactored tests to use `withr::local_tempdir()` for better test isolation and cleanup.
  - Improved test descriptions to be more specific and informative.
  - Enhanced error handling with better retry logic and rate limiting.

* Technical improvements:
  - Added support for custom user agent headers via `TRUD_USER_AGENT` environment variable.
  - Improved file existence handling in `download_item()` with clearer warning messages.
  - Enhanced request handling with retry logic, and rate limiting.
  - Consistently return file paths invisibly from `download_item()`.

# trud 0.1.0

* Initial CRAN submission.
