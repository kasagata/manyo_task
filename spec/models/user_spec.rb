require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: '', email: 'test1@test.com', password: 'password', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test1', email: '', password: 'password', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test1', email: 'test1@test.com', password: '', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user1 = User.create(name: 'test1', email: 'test1@test.com', password: 'password', admin: false)
        user2 = User.create(name: 'test2', email: 'test1@test.com', password: 'password', admin: false)
        expect(user2).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test1', email: 'test1@test.com', password: 'pass', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user1 = FactoryBot.build(:user)
        user2 = User.create(name: 'test2', email: 'test2@test.com', password: 'password', admin: false)
        expect(user2).to be_valid
      end
    end
  end
end