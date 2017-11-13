describe Issue do
  describe '#of_user?' do
    let(:issue) { FactoryBot.create(:issue) }

    context 'with author' do
      it 'should be truthy' do
        expect(issue.of_user?(issue.author.id)).to be_truthy
      end
    end

    context 'with other user' do
      it 'should be falsey' do
        user = FactoryBot.create(:user)

        expect(issue.of_user?(user.id)).to be_falsey
      end
    end

    context 'with nil' do
      it 'should be falsey' do
        expect(issue.of_user?(nil)).to be_falsey
      end
    end
  end

  describe '#pending?' do
    context 'when has pending status' do
      subject { FactoryBot.create(:issue) }

      its(:pending?) { is_expected.to be_truthy }
    end

    context 'when has other status' do
      subject { FactoryBot.create(:issue, :resolved) }

      its(:pending?) { is_expected.to be_falsey}
    end
  end

  describe '#in_progress?' do
    context 'when has in_progress status' do
      subject { FactoryBot.create(:issue, :in_progress) }

      its(:in_progress?) { is_expected.to be_truthy }
    end

    context 'when has other status' do
      subject { FactoryBot.create(:issue, :resolved) }

      its(:in_progress?) { is_expected.to be_falsey}
    end
  end

  describe '#unassigned?' do
    context 'when has assignee' do
      subject { FactoryBot.create(:issue, :in_progress) }

      its(:unassigned?) { is_expected.to be_falsey}
    end

    context 'when has not assignee' do
      subject { FactoryBot.create(:issue) }

      its(:unassigned?) { is_expected.to be_truthy }
    end
  end

  describe '#assigned_by?' do
    context 'when has assignee' do
      let(:issue) { FactoryBot.create(:issue, :in_progress) }

      context 'with assignee' do
        it 'should be truthy' do
          expect(issue.assigned_by?(issue.assignee.id)).to be_truthy
        end
      end

      context 'with other user' do
        it 'should be falsey' do
          user = FactoryBot.create(:user)

          expect(issue.assigned_by?(user.id)).to be_falsey
        end
      end

      context 'with nil' do
        it 'should be falsey' do
          expect(issue.assigned_by?(nil)).to be_falsey
        end
      end
    end

    context 'when has not assignee' do
      let(:issue) { FactoryBot.create(:issue) }

      it 'should be falsey' do
        user = FactoryBot.create(:user)

        expect(issue.assigned_by?(user.id)).to be_falsey
      end
    end
  end
end
