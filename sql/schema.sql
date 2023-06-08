-- A Libraries.io project is the definition of a package available from one of the 37 Package Managers that it supports.

CREATE TABLE IF NOT EXISTS projects (id INTEGER PRIMARY KEY, -- The unique primary key of the project in the Libraries.io database
    platform VARCHAR, -- The name of the Package manager the project is available on.
    name VARCHAR, created_timestamp TIMESTAMP, -- The timestamp of when Libraries.io first discovered the project.
    updated_timestamp TIMESTAMP, -- The timestamp of when Libraries.io last saved a change to the project.
    description VARCHAR, -- Description provided by the package manager, falling back to description from repository if empty.
    keywords VARCHAR, -- Comma separated array of keywords if supported by package manager.
    homepage_url VARCHAR, -- URL of webpage or repository as provided by package managers that support it.
    licenses VARCHAR, -- Comma separated array of SPDX identifiers for licenses declared in package manager meta data or submitted manually by Libraries.io user via "project suggection" feature.
    repository_url VARCHAR, -- URL of source code repository declared in package manager metadata or submitted manually by Libraries.io user via "project suggection" feature.
    versions_count INTEGER, -- Number of published versions of the project found by Libraries.io.
    sourcerank INTEGER, -- Libraries.io defined score based on quality, popularity and community metrics.
    latest_release_publish_timestamp TIMESTAMP, -- Time of the latest release detected by Libraries.io (ordered by semver, falling back to publish date for invalid semver).
    latest_release_number VARCHAR, -- Version number of the latest release detected by Libraries.io (ordered by semver, falling back to publish date for invalid semver).
    package_manager_id INTEGER, -- Unique ID of project from package manager API, only currently used by PlatformIO.
    dependent_projects_count INTEGER, -- Number of other projects that declare the project as a dependency in one or more of their versions
    LANGUAGE VARCHAR, -- primary programming language the project is written in, pulled from the repository if source is hosted on GitHub
    status VARCHAR, -- Either Active, Deprecated, Unmaintained, Help Wanted, Removed, no value also means active. Updated when detected by Libraries.io or submitted manually by Libraries.io user via "project suggection" feature
    last_synced_timestamp TIMESTAMP, -- Timestamp of when Libraries.io last synced the project from its package manager API
    dependent_repositories_count INTEGER, -- The total count of open source repositories that list the project as a dependency as detected by Libraries.io.
    repository_id INTEGER -- The unique primary key of the repository for this project in the Libraries.io database
);

-- A Libraries.io version is a definition of an imutable published version of a Project from a package manager. Not all package managers have a concept of
-- publishing versions, often relying directly on tags/branches from a source control.

CREATE TABLE IF NOT EXISTS versions (id INTEGER PRIMARY KEY, -- The unique primary key of the version in the Libraries.io database
    platform VARCHAR, -- The name of the Package manager the version is available on.
    project_name VARCHAR, -- The name of the project the version belongs to.
    project_id INTEGER, -- The unique primary key of the project for this version in the Libraries.io database
    version_number VARCHAR, -- The number of the release, often confirms to semantic versioning.
    published_timestamp TIMESTAMP, -- The timestamp of when the version was published
    created_timestamp TIMESTAMP, --The timestamp of when the version was first detected by Libraries.io.
    updated_timestamp TIMESTAMP -- The timestamp of when the version was last saved by Libraries.io
);

-- A Libraries.io tag is equivelant to a tag in git or other source control systems.

CREATE TABLE IF NOT EXISTS tags (id INTEGER PRIMARY KEY, -- The unique primary key of the tag in the Libraries.io database
    host_type VARCHAR, -- Which website the tags repository is hosted on, either GitHub, GitLab or Bitbucket.
    repository_name_with_owner VARCHAR, -- The repository name and owner seperated by a slash, also maps to the url slug on the given repository host e.g. librariesio/libraries.io.
    repository_id INTEGER, -- The unique primary key of the repository for this tag in the Libraries.io database
    tag_name VARCHAR, -- The name of the tag, often is a version number but could be any freeform string.
    tag_git_sha VARCHAR, -- Sha of the object that the tag is pointing at in the repository.
    tag_published_timestamp TIMESTAMP, -- The timestamp of when the tag was published.
    tag_created_timestamp TIMESTAMP, -- The timestamp of when the tag was first saved by Libraries.io.
    tag_updated_timestamp TIMESTAMP -- The timestamp of when the tag was last saved by Libraries.io.
);

-- Libraries.io dependencies belong to versions of a project, each version can have different sets of dependencies with different versions.
-- Dependencies point at a specific version or range of versions of other projects, the resolution of that project version change over time
-- as new versions are published and dependent on the specifics of the platform.  Almost all package managers dependencies will be from the
-- same package manager, the only exception is Atom, which pulls its dependencies from the NPM package manager, hence the extra `Dependency
-- Platform` field.

CREATE TABLE IF NOT EXISTS dependencies (id INTEGER PRIMARY KEY, -- The unique primary key of the dependency in the Libraries.io database
    platform VARCHAR, -- The name of the Package manager the dependency is available on.
    project_name VARCHAR, -- The name of the project the dependency belongs to.
    project_id INTEGER, -- The unique primary key of the project for this dependency in the Libraries.io database
    version_number VARCHAR, -- The number of the version that the dependency belongs to.
    version_id INTEGER, -- The unique primary key of the version for this dependency in the Libraries.io database
    dependency_name VARCHAR, -- The name of the project that the dependency specifies.
    dependency_platform VARCHAR, -- The name of the package manager that the project that the dependency specifies is available from (only different for Atom).
    dependency_kind VARCHAR, -- The type of dependency, often declared for the phase of usage, e.g. runtime, test, development, build.
    optional_dependency BOOLEAN, -- Is the dependency optional?.
    dependency_requirements VARCHAR, -- The version or range of versions that the dependency specifies, resolution of that to a particular version is package manager specific.
    dependency_project_id INTEGER -- The unique primary key of the project for this dependency in the Libraries.io database
);

-- A Libraries.io repository represents a publically accessible source code repository from either github.com, gitlab.com or bitbucket.org.

CREATE TABLE IF NOT EXISTS repositories (id INTEGER PRIMARY KEY, -- The unique primary key of the repository in the Libraries.io database
    host_type VARCHAR, -- Which website the repository is hosted on, either GitHub, GitLab or Bitbucket.
    name_with_owner VARCHAR, -- The repository name and owner seperated by a slash, also maps to the url slug on the given repository host e.g. librariesio/libraries.io.
    description VARCHAR, -- Description of repository.
    fork BOOLEAN, -- Is the repository a fork of another.
    created_timestamp TIMESTAMP, -- Timestamp of when the repository was created on the host.
    updated_timestamp TIMESTAMP, -- Timestamp of when the repository was last saved by Libraries.io.
    last_pushed_timestamp TIMESTAMP, -- Timestamp of when the repository was last pushed to, only available for GitHub repositories.
    homepage_url VARCHAR, -- URL of a declared homepage or other website for the repository.
    size INTEGER, -- Size of the repository in kilobytes, only available for GitHub and Bitbucket.
    stars_count INTEGER, -- Number of stars on the repository, only available for GitHub and GitLab.
    LANGUAGE VARCHAR, -- Primary programming language the project is written in, only available for GitHub and Bitbucket.
    issues_enabled BOOLEAN, -- Is the bug tracker enabled for this repository?.
    wiki_enabled BOOLEAN, -- Is the wiki enabled for this repository?.
    pages_enabled BOOLEAN, -- Is GitHub pages enabled for this repository? only possible for GitHub.
    forks_count INTEGER, -- Number of forks of this repository.
    mirror_url VARCHAR, -- URL of the repositroy of which this is a mirror of, only present if this repository is a mirror of another.
    open_issues_count INTEGER, -- Number of open issues on the repository bug tracker, only available for GitHub and GitLab.
    default_branch VARCHAR, -- Primary branch of the repository.
    watchers_count INTEGER, -- Number of subscribers to all notifications for the repository, only available for GitHub and Bitbucket.
    UUID VARCHAR, -- ID of the repository on the remote host, not unique between GitLab and GitHub repositories.
    fork_source_name_with_owner VARCHAR, -- If the repository is a fork, the repository name and owner seperated by a slash of the repository if was forked from.
    license VARCHAR, -- SPDX identifier of the license of the repository, only available for GitHub repositories.
    contributors_count INTEGER, -- Number of unique contributors that have committed to the default branch.
    readme_filename VARCHAR, -- If a readme file has been detected, the full name of the readme file, e.g README.md.
    changelog_filename VARCHAR, -- If a changelog file has been detected, the full name of the changelog file, e.g changelog.txt.
    contributing_guidelines_filename VARCHAR, -- If a contributing guidelines file has been detected, the full name of the contributing guidelines file, e.g contributing.md.
    license_filename VARCHAR, -- If a license file has been detected, the full name of the license file, e.g LICENSE.
    code_of_conduct_filename VARCHAR, -- If a code of conduct file has been detected, the full name of the code of conduct file, e.g code_of_conduct.md.
    security_threat_model_filename VARCHAR, -- If a Security Threat Model file has been detected, the full name of the Security Threat Model file, e.g threatmodel.md.
    security_audit_filename VARCHAR, -- If a Security Audit file has been detected, the full name of the Security Audit file, e.g security.md.
    status VARCHAR, --- Either Active, Deprecated, Unmaintained, Help Wanted, Removed, no value also means active. Updated when detected by Libraries.io or su. manually by Libraries.io user via "repo suggection" feature
    last_synced_timestamp TIMESTAMP, -- Timestamp of when Libraries.io last synced the repository from the host API.
    sourcerank INTEGER, -- Libraries.io defined score based on quality, popularity and community metrics.
    display_name VARCHAR, -- Display name for the repository, only available for GitLab repositories.
    foo VARCHAR, -- FIX for bad column
    scm_type VARCHAR, -- Type of source control repository uses, always "git" for GitHub and GitLab.
    pull_requests_enabled BOOLEAN, -- Are pull requests enabled for this repository? Only available for GitLab repositories.
    logo_url VARCHAR, -- Custom logo url for repository, only available for GitLab repositories.
    keywords VARCHAR -- Comma separated array of keywords, called "topics" on GitHub, only available for GitHub and GitLab.
);

-- A Libraries.io repository dependency is where a dependency on a Project from a package manager has been specified in a manifest file,
-- either as a manually added dependency commited by a user or listed as a generated dependency listed in a lockfile that has been
-- automatically generated by a package manager and commited.

CREATE TABLE IF NOT EXISTS repository_dependencies (id INTEGER PRIMARY KEY, -- The unique primary key of the repository dependency in the Libraries.io database
    host_type VARCHAR, -- Which website the dependencys repository is hosted on, either GitHub, GitLab or Bitbucket.
    repository_name_with_owner VARCHAR, -- The repository name and owner seperated by a slash, also maps to the url slug on the given repository host e.g. librariesio/libraries.io.
    repository_id INTEGER, -- The unique primary key of the repository for this dependency in the Libraries.io database
    manifest_platform VARCHAR, -- Which package manager the dependency listed in the manifest should use.
    manifest_filepath VARCHAR, -- Path to the file where the dependency is declared within the repository.
    git_branch VARCHAR, -- Which branch was the manifest loaded from the repository.
    manifest_kind VARCHAR, -- Either manifest or lockfile, manifests are written by humans, lockfiles contain full resolved dependency tree.
    optional BOOLEAN, -- Is the dependency optional?.
    dependency_project_name VARCHAR, -- The name of the project that the dependency specifies.
    dependency_requirements VARCHAR, -- The version or range of versions that the dependency specifies, resolution of that to a particular version is package manager specific.
    dependency_kind VARCHAR, -- The type of dependency, often declared for the phase of usage, e.g. runtime, test, development, build.
    dependency_project_id INTEGER -- The unique primary key of the project for this dependency in the Libraries.io database
);

-- This is an alternative projects export that denormalizes a projects related source code repository inline to reduce the need to join
-- between two data sets.

CREATE TABLE IF NOT EXISTS projects_with_repository_fields (id INTEGER PRIMARY KEY, -- The unique primary key of the project in the Libraries.io database
    platform VARCHAR, -- The name of the Package manager the project is available on.
    name VARCHAR, -- The name of the project, unique by Platform (case sensitive).
    created_timestamp TIMESTAMP, -- The timestamp of when Libraries.io first discovered the project.
    updated_timestamp TIMESTAMP, -- The timestamp of when Libraries.io last saved a change to the project.
    description VARCHAR, -- Description provided by the package manager, falling back to description from repository if empty.
    keywords VARCHAR, -- Comma separated array of keywords if supported by package manager.
    homepage_url VARCHAR, -- URL of webpage or repository as provided by package managers that support it.
    licenses VARCHAR, -- Comma separated array of SPDX identifiers for licenses declared in package manager meta data or submitted manually by Libraries.io user via "project suggection" feature.
    repository_url VARCHAR, -- URL of source code repository declared in package manager metadata or submitted manually by Libraries.io user via "project suggection" feature.
    versions_count INTEGER, -- Number of published versions of the project found by Libraries.io.
    sourcerank INTEGER, -- Libraries.io defined score based on quality, popularity and community metrics.
    latest_release_publish_timestamp TIMESTAMP, -- Time of the latest release detected by Libraries.io (ordered by semver, falling back to publish date for invalid semver).
    latest_release_number VARCHAR, -- Version number of the latest release detected by Libraries.io (ordered by semver, falling back to publish date for invalid semver).
    package_manager_id INTEGER, -- Unique ID of project from package manager API, only currently used by PlatformIO.
    dependent_projects_count INTEGER, -- Number of other projects that declare the project as a dependency in one or more of their versions
    LANGUAGE VARCHAR, -- primary programming language the project is written in, pulled from the repository if source is hosted on GitHub
    status VARCHAR, -- Either Active, Deprecated, Unmaintained, Help Wanted, Removed, no value also means active. Updated when detected by Libraries.io or submitted manually by Libraries.io user via "project suggection" feature
    last_synced_timestamp TIMESTAMP, -- Timestamp of when Libraries.io last synced the project from its package manager API
    dependent_repositories_count INTEGER, -- The total count of open source repositories that list the project as a dependency as detected by Libraries.io.
    repository_id INTEGER, -- The unique primary key of the repository for this project in the Libraries.io database
    repository_host_type VARCHAR, -- Which website the repository is hosted on, either GitHub, GitLab or Bitbucket.
    repository_name_with_owner VARCHAR, -- The repository name and owner seperated by a slash, also maps to the url slug on the given repository host e.g. librariesio/libraries.io.
    repository_description VARCHAR, -- Description of repository.
    repository_fork BOOLEAN, -- Is the repository a fork of another.
    repository_created_timestamp TIMESTAMP, -- Timestamp of when the repository was created on the host.
    repository_updated_timestamp TIMESTAMP, -- Timestamp of when the repository was last saved by Libraries.io.
    repository_last_pushed_timestamp TIMESTAMP, -- Timestamp of when the repository was last pushed to, only available for GitHub repositories.
    repository_homepage_url VARCHAR, -- URL of a declared homepage or other website for the repository.
    repository_size INTEGER, -- Size of the repository in kilobytes, only available for GitHub and Bitbucket.
    repository_stars_count INTEGER, -- Number of stars on the repository, only available for GitHub and GitLab.
    repository_language VARCHAR, -- Primary programming language the project is written in, only available for GitHub and Bitbucket.
    repository_issues_enabled BOOLEAN, -- Is the bug tracker enabled for this repository?.
    repository_wiki_enabled BOOLEAN, -- Is the wiki enabled for this repository?.
    repository_pages_enabled BOOLEAN, -- Is GitHub pages enabled for this repository? only possible for GitHub.
    repository_forks_count INTEGER, -- Number of forks of this repository.
    repository_mirror_url VARCHAR, -- URL of the repositroy of which this is a mirror of, only present if this repository is a mirror of another.
    repository_open_issues_count INTEGER, -- Number of open issues on the repository bug tracker, only available for GitHub and GitLab.
    repository_default_branch VARCHAR, -- Primary branch of the repository.
    repository_watchers_count INTEGER, -- Number of subscribers to all notifications for the repository, only available for GitHub and Bitbucket.
    repository_uuid VARCHAR, -- ID of the repository on the remote host, not unique between GitLab and GitHub repositories.
    repository_fork_source_name_with_owner VARCHAR, -- If the repository is a fork, the repository name and owner seperated by a slash of the repository if was forked from.
    repository_license VARCHAR, -- SPDX identifier of the license of the repository, only available for GitHub repositories.
    repository_contributors_count INTEGER, -- Number of unique contributors that have committed to the default branch.
    repository_readme_filename VARCHAR, -- If a readme file has been detected, the full name of the readme file, e.g README.md.
    repository_changelog_filename VARCHAR, -- If a changelog file has been detected, the full name of the changelog file, e.g changelog.txt.
    repository_contributing_guidelines_filename VARCHAR, -- If a contributing guidelines file has been detected, the full name of the contributing guidelines file, e.g contributing.md.
    repository_license_filename VARCHAR, -- If a license file has been detected, the full name of the license file, e.g LICENSE.
    repository_code_of_conduct_filename VARCHAR, -- If a code of conduct file has been detected, the full name of the code of conduct file, e.g code_of_conduct.md.
    repository_security_threat_model_filename VARCHAR, -- If a Security Threat Model file has been detected, the full name of the Security Threat Model file, e.g threatmodel.md.
    repository_security_audit_filename VARCHAR, -- If a Security Audit file has been detected, the full name of the Security Audit file, e.g security.md.
    repository_status VARCHAR, --- Either Active, Deprecated, Unmaintained, Help Wanted, Removed, no value also means active. Updated when detected by Libraries.io or su. manually by Libraries.io user via "repo suggection" feature
    repository_last_synced_timestamp TIMESTAMP, -- Timestamp of when Libraries.io last synced the repository from the host API.
    repository_sourcerank INTEGER, -- Libraries.io defined score based on quality, popularity and community metrics.
    repository_display_name VARCHAR, -- Display name for the repository, only available for GitLab repositories.
    foo VARCHAR, -- FIX for bad column
    repository_scm_type VARCHAR, -- Type of source control repository uses, always "git" for GitHub and GitLab.
    repository_pull_requests_enabled BOOLEAN, -- Are pull requests enabled for this repository? Only available for GitLab repositories.
    repository_logo_url VARCHAR, -- Custom logo url for repository, only available for GitLab repositories.
    repository_keywords VARCHAR -- Comma separated array of keywords, called "topics" on GitHub, only available for GitHub and GitLab.
);
