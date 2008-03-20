WorkflowBuilder.workflow do
  WorkflowBuilder.step "submitted","review","reviewed"
  WorkflowBuilder.step "reviewed","publish","published"
  WorkflowBuilder.step "published", "auto","published"
end
