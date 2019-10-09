Deface::Override.new :virtual_path  => 'issues/new',
                     :name          => 'add-drafts-action-in-new-issue-form',
                     :insert_after  => '#watchers_form_container',
                     :partial       => "drafts/issue_new"
