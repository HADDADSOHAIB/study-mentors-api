require 'rails_helper'

RSpec.describe Teacher, type: :model do
  let(:teacher) { build(:teacher) }

  it 'should be valid' do
    assert teacher.valid?
  end

  it 'should be not valid when :fullname is nil' do
    teacher.fullname = nil
    teacher.save
    expect(teacher).to_not be_valid
  end

  it 'should be not valid when :email is nil' do
    teacher.email = nil
    teacher.save
    expect(teacher).to_not be_valid
  end

  it 'should be not valid when :email is duplicated' do
    teacher.save
    duplicate_teacher = teacher.dup
    expect(duplicate_teacher).to_not be_valid
  end

  it 'should be not valid when :password is nil' do
    teacher.password = nil
    teacher.save
    expect(teacher).to_not be_valid
  end
end
