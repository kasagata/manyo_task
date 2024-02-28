require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'Todo', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: 'Todo', content: '企画書を作成する。', deadline_on: '2022-02-16', priority: 1, status: 0)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: 1, status: 0) }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: 2, status: 1) }
    let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: 0, status: 2) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        result = Task.search_title('first')
        expect(result).to include(task1)
        expect(result).not_to include(task2)
        # 検索されたテストデータの数を確認する
        expect(result.size).to eq 1

      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        result = Task.search_status(0)
        expect(result).to include(task1)
        expect(result).not_to include(task2)
        # 検索されたテストデータの数を確認する
        expect(result.size).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        result = Task.search_title('first').search_status(0)
        expect(result).to include(task1)
        expect(result).not_to include(task2)
        # 検索されたテストデータの数を確認する
        expect(result.size).to eq 1
      end
    end
  end
end
