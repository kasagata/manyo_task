require 'rails_helper'

 RSpec.describe 'ユーザ管理機能', type: :system do
   describe '登録機能' do
     context 'ユーザを登録した場合' do
       it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in "名前", with: "testuser"
        fill_in "メールアドレス", with:"testuser@test.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        click_button "登録する"
        expect(page).to have_text 'アカウントを登録しました'
       end
     end
     context 'ログインせずにタスク一覧画面に遷移した場合' do
       it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_text 'ログインしてください'
       end
     end
   end

   describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user)}
    let!(:task) { FactoryBot.create(:task, title: 'first_task', created_at:'2022-02-16', deadline_on: '2022-02-16', priority: 1, status: 0, user: user) }
    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_button "ログイン"
    end
    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_text 'ログインしました'
      end
      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(page).to have_text user.name
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit '/users/134'
        expect(page).to have_text 'アクセス権限がありません'
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link "ログアウト"
        expect(page).to have_text 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    let!(:user) { FactoryBot.create(:user, admin: true)}
    let!(:task) { FactoryBot.create(:task, title: 'first_task', created_at:'2022-02-16', deadline_on: '2022-02-16', priority: 1, status: 0) }
    let!(:user1) { FactoryBot.create(:user)}
    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in 'session[email]', with: user.email
        fill_in 'session[password]', with: user.password
        click_button "ログイン"
      end
      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_text 'ユーザ一覧ページ'
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in "名前", with: "testuser"
        fill_in "メールアドレス", with:"testuser@test.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        check "管理者権限"
        click_button "登録する"
        expect(page).to have_text 'ユーザを登録しました'
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_users_path
        update_user = all('body tr').last
        within(update_user) do
          find('.show-user').click
        end
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit admin_users_path
        update_user = all('body tr').last
        within(update_user) do
          find('.edit-user').click
        end
      end
      
      it 'ユーザを削除できる' do
        visit admin_users_path
        delete_user = all('body tr').last
        within(delete_user) do
          accept_confirm do
            find('.destroy-user').click
          end
        end
        expect(page).to have_text 'ユーザを削除しました'
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in 'session[email]', with: user1.email
        fill_in 'session[password]', with: user1.password
        click_button "ログイン"
      end
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_text '管理者以外アクセスできません'
      end
    end
  end
end