const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const jwt = require("jsonwebtoken");
admin.initializeApp();

// 環境変数の取得
const ISSUER_ID = functions.config().appstore.issuer_id;
const KEY_ID = functions.config().appstore.key_id;
const PRIVATE_KEY = functions.config().appstore.private_key;
const REVENUECAT_PROJECT_ID = functions.config().revenuecat.project_id;
const REVENUECAT_API_KEY = functions.config().revenuecat.api_key;

exports.createProduct = functions.firestore
    .document("users/{userId}/uploadvideos/{videoId}")
    .onCreate(async (snapshot, context) => {
        const videoData = snapshot.data();

        // 動画情報の取得
        const { title, price } = videoData;

        // 商品IDを生成
        const productId = `video_${context.params.videoId}`;

        try {
            // iOSの課金商品登録 (App Store Connect API)
            await registerProductToAppStore(productId, title, price);

            // Androidの課金商品登録 (Google Play Developer API)
            /* 動作確認優先のためコメントアウト
            await registerProductToGooglePlay(productId, title, price);
            */

            // RevenueCatへの登録
            await registerProductToRevenueCat(productId, price);

            console.log(`Product registered successfully: ${productId}`);
        } catch (error) {
            console.error(`Error creating product: ${error.message}`);
        }
    });

async function registerProductToAppStore(productId, title, price) {
    // JWTトークンの生成
    const jwtToken = jwt.sign(
        {
            iss: ISSUER_ID,
            exp: Math.floor(Date.now() / 1000) + (20 * 60), // トークンの有効期限（20分間）
            aud: "appstoreconnect-v1",
        },
        PRIVATE_KEY, // 環境変数から取得した秘密鍵
        {
            algorithm: "ES256",
            header: {
                alg: "ES256",
                kid: KEY_ID, // 環境変数から取得したKey ID
            },
        }
    );

    // App Store Connect APIにリクエスト
    const response = await axios.post(
        "https://api.appstoreconnect.apple.com/v1/products",
        {
            data: {
                attributes: {
                    productId,
                    name: title,
                    price,
                },
            },
        },
        {
            headers: {
                Authorization: `Bearer ${jwtToken}`, // JWTトークンをヘッダーに追加
                "Content-Type": "application/json",
            },
        }
    );
    return response.data;
}

async function registerProductToRevenueCat(productId, price) {
    const response = await axios.post(
        `https://api.revenuecat.com/v1/projects/${REVENUECAT_PROJECT_ID}/products`, // 環境変数からプロジェクトIDを取得
        {
            product_id: productId,
            price: price,
            platform: "ios", // または "android"
        },
        {
            headers: {
                Authorization: `Bearer ${REVENUECAT_API_KEY}`, // 環境変数からAPIキーを取得
                "Content-Type": "application/json",
            },
        }
    );
    return response.data;
}
