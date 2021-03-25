module Retest
  module VersionControl::SharedInterface
    def test_interface
      assert_respond_to @subject.class, :installed?
      assert_respond_to @subject, :name
      assert_respond_to @subject, :files
    end
  end
end