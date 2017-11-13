Issues::Form = Dry::Validation.Form do
  required(:name).filled(:str?, {min_size?: 1})
  optional(:description).filled(:str?)
end
