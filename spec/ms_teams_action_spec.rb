describe Fastlane::Actions::MsTeamsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ms_teams plugin is working!")

      Fastlane::Actions::MsTeamsAction.run(nil)
    end
  end
end
