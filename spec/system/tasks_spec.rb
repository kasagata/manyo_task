require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # new_taskへアクセスし、データを入力
        visit new_task_path
        fill_in "タイトル", with: "書類作成"
        fill_in "内容", with:"企画書を作成する。"
        fill_in "終了期限", with: DateTime.new(2024, 2, 28)
        select '高', from: '優先度'
        select '未着手', from: 'ステータス'
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
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', created_at:'2022-02-16', deadline_on: '2022-02-16', priority: 1, status: 0) }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', created_at:'2022-02-17', deadline_on: '2022-02-17', priority: 2, status: 1) }
    let!(:task3) { FactoryBot.create(:task, title: 'third_task', created_at:'2022-02-18', deadline_on: '2022-02-18', priority: 0, status: 2) }
    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'third_task'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, title: "AAATask", deadline_on: '2022-02-16', priority: 0, status: 2)
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'AAATask'
      end
    end
    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "終了期限"
          sleep 1
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'first_task'
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "優先度"
          sleep 1
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'second_task'
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in 'search_title', with: "first"
          click_button "検索"
          sleep 1
          task_list = all('tbody tr')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          task_list.each do |task|
            expect(task).to have_content 'first_task'
            expect(task).to_not have_content 'second'
          end
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select '未着手', from: 'search_status'
          click_button "検索"
          sleep 1
          task_list = all('tbody tr')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          task_list.each do |task|
            expect(task).to have_content '未着手'
            expect(task).to_not have_content '完了'
          end
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          visit tasks_path
          fill_in 'search_title', with: "first"
          select '未着手', from: 'search_status'
          click_button "検索"
          sleep 1
          task_list = all('tbody tr')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          task_list.each do |task|
            expect(task).to have_content 'first'
            expect(task).to_not have_content 'second'
          end
        end
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