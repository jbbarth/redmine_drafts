Deface::Override.new :virtual_path  => 'issues/_edit',
                     :name          => 'add-save-draft-button-in-issue-form',
                     :insert_after => 'div.box',
                     :partial       => "drafts/save_draft_button"
