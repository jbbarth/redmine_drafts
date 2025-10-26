Deface::Override.new :virtual_path  => 'issues/new',
                     :name          => 'add-drafts-action-in-new-issue-form',
                     :insert_after  => '#watchers_form_container',
                     :partial       => "drafts/issue_new"

Deface::Override.new :virtual_path  => 'issues/new',
                     :name          => 'add-save-draft-button-in-new-issue-form',
                     :insert_after  => 'div.box.tabular',
                     :partial       => "drafts/save_draft_button"
