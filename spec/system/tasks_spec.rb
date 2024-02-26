require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # new_taskへアクセスし、データを入力
        visit new_task_path
        fill_in "タイトル", with: "書類作成"
        fill_in "内容", with:"企画書を作成する。"
        # Create Taskボタンをクリックする
        click_button "登録する"
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        expect(page).to have_text 'タスクを登録しました'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '一覧表示機能' do
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', created_at: '2022-02-18') }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', created_at: '2022-02-17') }
    let!(:task3) { FactoryBot.create(:task, title: 'third_task', created_at: '2022-02-16') }
    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, title: "AAATask")
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'AAATask'
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content '書類作成'
       end
     end
  end
end