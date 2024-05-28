module RedmineFeedbackButtons
    module Hooks
      class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
        def view_issues_show_details_bottom(context={})
          context[:controller].send(:render_to_string, {
            partial: 'issues/feedback_buttons',
            locals: context
          })
        end
      end
    end
  end
  