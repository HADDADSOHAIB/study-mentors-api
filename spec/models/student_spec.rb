require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }

  it 'should be valid' do
    assert student.valid?
  end

  it 'should be not valid when :fullname is nil' do
    student.fullname = nil
    student.save
    expect(student).to_not be_valid
  end

  it 'should be not valid when :email is nil' do
    student.email = nil
    student.save
    expect(student).to_not be_valid
  end

  it 'should be not valid when :email is duplicated' do
    student.save
    duplicate_student = student.dup
    expect(duplicate_student).to_not be_valid
  end

  it 'should be not valid when :password is nil' do
    student.password = nil
    student.save
    expect(student).to_not be_valid
  end
end
