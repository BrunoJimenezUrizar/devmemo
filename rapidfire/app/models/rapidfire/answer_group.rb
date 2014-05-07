module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
    belongs_to :user, polymorphic: true#, :class => "Reciclauc::MobileUser" probar esto cuando este lista la parte android
    belongs_to :mobile_user
    has_many   :answers, inverse_of: :answer_group, autosave: true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :question_group, :user, :active, :mobile_user
    end
  end
end
