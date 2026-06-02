# Roadmap

## Product Roadmap

QWON は段階的に「ローカル AI チャット」から「モバイル AI ランタイム」へ進める。優先順位は常に、機能数よりも runtime の質を取る。

Delivery workflow (Codex / Cursor role split): [agent_collaboration_workflow.md](./agent_collaboration_workflow.md).

## Guiding Priorities

- ローカル推論基盤
- セマンティックルーティング
- コンテキスト圧縮
- バッテリーと熱制御
- プライバシー境界の明確化

## Phase 0: Foundation

目的:

- リポジトリと責務分離の確立
- iOS アプリ基盤の初期化
- runtime 中心のアーキテクチャ確立

成果物:

- `app/ios/` のアプリ骨格
- `runtime/` の主要モジュール定義
- API キー管理方針
- ドキュメントと要件整理

完了条件:

- UI と runtime の責務分離が明確
- ローカルモデルとクラウドモデルの接続方針が固定

## Phase 1: MVP

目的:

- ローカルファースト AI 体験を成立させる

最初の正式リリースは Phase 1 全体ではなく、[Qwen text-only alpha](./qwen_text_only_alpha_release.md) として切り出す。OCR、compression v1、LiteRT-LM adoption、音声、live vision は alpha 後のバージョンアップ要件として扱う。

対象機能:

- チャット UI
- ローカル LLM 推論経路
- OpenAI / Anthropic 接続
- 自動モデル振り分け
- コンテキスト圧縮
- API キー設定
- OCR と基本 Vision 入力

重点課題:

- ローカル応答速度
- クラウド送信量削減
- エスカレーション精度
- iPhone 上での動作安定性

成功指標:

- iPhone 単体でローカル会話可能
- 手動モデル選択なしでも実用になる
- トークン削減が目に見える
- OCR 入力が使い物になる

## Phase 2: Runtime Expansion

目的:

- runtime と記憶能力を実用レベルへ拡張

対象機能:

- ローカルメモリ
- ベクトル検索
- 軽量 RAG
- 音声対話
- Vision 強化
- PDF / ドキュメント解析

重点課題:

- メモリ品質
- 誤想起の抑制
- 音声レイテンシ
- マルチモーダル処理の電力効率

成功指標:

- 継続利用で文脈保持が改善する
- 音声と画像入力が会話に自然統合される
- ローカル処理率を維持したまま体験が向上する

## Phase 3: Cognitive Runtime

目的:

- QWON を汎用チャットから知能実行基盤へ進化させる

対象機能:

- エージェント実行
- iOS ショートカット連携
- LAN 内 LLM 接続
- Mac 連携
- MCP 対応
- 常時知能層

重点課題:

- 常駐時の電力管理
- イベント駆動設計
- 安全な権限境界
- ローカルメモリとアクション実行の統合

成功指標:

- 会話外の実行文脈でも runtime が価値を出す
- 常時利用に耐える熱・電池特性を持つ

## Cross-Phase Technical Themes

全フェーズで継続的に改善する項目:

- モデル切替コスト削減
- プロンプト圧縮最適化
- メモリの重複抑制
- ルーティング精度
- ストリーミング品質
- ローカルモデル評価

## Deferred Items

後回しにする項目:

- ライトユーザー向け大規模オンボーディング
- ソーシャル機能
- デスクトップ主導の体験設計
- 常時重いバックグラウンド処理

## Execution Order

実装優先度:

1. ローカル推論基盤
2. ルーティング
3. 圧縮
4. API キー管理
5. バッテリー最適化
6. Vision
7. 音声
8. RAG
9. 長期メモリ
