/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


--
-- FUNCTION
--
DELIMITER ;;

CREATE OR REPLACE FUNCTION toU64String(n bigint unsigned) RETURNS varchar(24) CHARSET utf8mb4 COLLATE utf8mb4_bin
DETERMINISTIC
BEGIN
   RETURN CAST(n AS varchar(24));
END;;

CREATE OR REPLACE FUNCTION toU128String(n decimal(39, 0)) RETURNS varchar(48) CHARSET utf8mb4 COLLATE utf8mb4_bin
DETERMINISTIC
BEGIN
   RETURN CAST(n AS varchar(48));
END;;

DELIMITER ;


--
-- VIEW
--
CREATE OR REPLACE VIEW vwSlotsUntilCheckpoint AS
SELECT
    t.slot,
    t.blockHeight,
    t.blockTime
FROM
    slots t
WHERE
    t.slot <= (SELECT checkpointBlockSlot FROM admState)
;

CREATE OR REPLACE VIEW vwJsonIxsProgramDeploy AS
SELECT
    t.txid,
    t.order,
    "programDeploy" AS "ix",
    JSON_OBJECT(
        'programData', t.programData
    ) AS "payload"
FROM ixsProgramDeploy t;

CREATE OR REPLACE VIEW vwJsonIxsAdminIncreaseLiquidity AS
SELECT
    t.txid,
    t.order,
    "adminIncreaseLiquidity" AS "ix",
    JSON_OBJECT(
        'dataLiquidity', toU128String(t.dataLiquidity),
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyAuthority', toPubkeyBase58(t.keyAuthority)
    ) AS "payload"
FROM ixsAdminIncreaseLiquidity t;

CREATE OR REPLACE VIEW vwJsonIxsCloseBundledPosition AS
SELECT
    t.txid,
    t.order,
    "closeBundledPosition" AS "ix",
    JSON_OBJECT(
        'dataBundleIndex', t.dataBundleIndex,
        'keyBundledPosition', toPubkeyBase58(t.keyBundledPosition),
        'keyPositionBundle', toPubkeyBase58(t.keyPositionBundle),
        'keyPositionBundleTokenAccount', toPubkeyBase58(t.keyPositionBundleTokenAccount),
        'keyPositionBundleAuthority', toPubkeyBase58(t.keyPositionBundleAuthority),
        'keyReceiver', toPubkeyBase58(t.keyReceiver)
    ) AS "payload"
FROM ixsCloseBundledPosition t;

CREATE OR REPLACE VIEW vwJsonIxsClosePosition AS
SELECT
    t.txid,
    t.order,
    "closePosition" AS "ix",
    JSON_OBJECT(
        'keyPositionAuthority', toPubkeyBase58(t.keyPositionAuthority),
        'keyReceiver', toPubkeyBase58(t.keyReceiver),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionMint', toPubkeyBase58(t.keyPositionMint),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram)
    ) AS "payload"
FROM ixsClosePosition t;

CREATE OR REPLACE VIEW vwJsonIxsCollectFees AS
SELECT
    t.txid,
    t.order,
    "collectFees" AS "ix",
    JSON_OBJECT(
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyPositionAuthority', toPubkeyBase58(t.keyPositionAuthority),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyTokenOwnerAccountA', toPubkeyBase58(t.keyTokenOwnerAccountA),
        'keyTokenVaultA', toPubkeyBase58(t.keyTokenVaultA),
        'keyTokenOwnerAccountB', toPubkeyBase58(t.keyTokenOwnerAccountB),
        'keyTokenVaultB', toPubkeyBase58(t.keyTokenVaultB),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1)
    ) AS "payload"
FROM ixsCollectFees t;

CREATE OR REPLACE VIEW vwJsonIxsCollectProtocolFees AS
SELECT
    t.txid,
    t.order,
    "collectProtocolFees" AS "ix",
    JSON_OBJECT(
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyCollectProtocolFeesAuthority', toPubkeyBase58(t.keyCollectProtocolFeesAuthority),
        'keyTokenVaultA', toPubkeyBase58(t.keyTokenVaultA),
        'keyTokenVaultB', toPubkeyBase58(t.keyTokenVaultB),
        'keyTokenDestinationA', toPubkeyBase58(t.keyTokenDestinationA),
        'keyTokenDestinationB', toPubkeyBase58(t.keyTokenDestinationB),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1)
    ) AS "payload"
FROM ixsCollectProtocolFees t;

CREATE OR REPLACE VIEW vwJsonIxsCollectReward AS
SELECT
    t.txid,
    t.order,
    "collectReward" AS "ix",
    JSON_OBJECT(
        'dataRewardIndex', t.dataRewardIndex,
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyPositionAuthority', toPubkeyBase58(t.keyPositionAuthority),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyRewardOwnerAccount', toPubkeyBase58(t.keyRewardOwnerAccount),
        'keyRewardVault', toPubkeyBase58(t.keyRewardVault),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'transferAmount0', toU64String(t.transferAmount0)
    ) AS "payload"
FROM ixsCollectReward t;

CREATE OR REPLACE VIEW vwJsonIxsDecreaseLiquidity AS
SELECT
    t.txid,
    t.order,
    "decreaseLiquidity" AS "ix",
    JSON_OBJECT(
        'dataLiquidityAmount', toU128String(t.dataLiquidityAmount),
        'dataTokenAmountMinA', toU64String(t.dataTokenAmountMinA),
        'dataTokenAmountMinB', toU64String(t.dataTokenAmountMinB),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keyPositionAuthority', toPubkeyBase58(t.keyPositionAuthority),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyTokenOwnerAccountA', toPubkeyBase58(t.keyTokenOwnerAccountA),
        'keyTokenOwnerAccountB', toPubkeyBase58(t.keyTokenOwnerAccountB),
        'keyTokenVaultA', toPubkeyBase58(t.keyTokenVaultA),
        'keyTokenVaultB', toPubkeyBase58(t.keyTokenVaultB),
        'keyTickArrayLower', toPubkeyBase58(t.keyTickArrayLower),
        'keyTickArrayUpper', toPubkeyBase58(t.keyTickArrayUpper),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1)
    ) AS "payload"
FROM ixsDecreaseLiquidity t;

CREATE OR REPLACE VIEW vwJsonIxsDeletePositionBundle AS
SELECT
    t.txid,
    t.order,
    "deletePositionBundle" AS "ix",
    JSON_OBJECT(
        'keyPositionBundle', toPubkeyBase58(t.keyPositionBundle),
        'keyPositionBundleMint', toPubkeyBase58(t.keyPositionBundleMint),
        'keyPositionBundleTokenAccount', toPubkeyBase58(t.keyPositionBundleTokenAccount),
        'keyPositionBundleOwner', toPubkeyBase58(t.keyPositionBundleOwner),
        'keyReceiver', toPubkeyBase58(t.keyReceiver),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram)
    ) AS "payload"
FROM ixsDeletePositionBundle t;

CREATE OR REPLACE VIEW vwJsonIxsIncreaseLiquidity AS
SELECT
    t.txid,
    t.order,
    "increaseLiquidity" AS "ix",
    JSON_OBJECT(
        'dataLiquidityAmount', toU128String(t.dataLiquidityAmount),
        'dataTokenAmountMaxA', toU64String(t.dataTokenAmountMaxA),
        'dataTokenAmountMaxB', toU64String(t.dataTokenAmountMaxB),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keyPositionAuthority', toPubkeyBase58(t.keyPositionAuthority),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyTokenOwnerAccountA', toPubkeyBase58(t.keyTokenOwnerAccountA),
        'keyTokenOwnerAccountB', toPubkeyBase58(t.keyTokenOwnerAccountB),
        'keyTokenVaultA', toPubkeyBase58(t.keyTokenVaultA),
        'keyTokenVaultB', toPubkeyBase58(t.keyTokenVaultB),
        'keyTickArrayLower', toPubkeyBase58(t.keyTickArrayLower),
        'keyTickArrayUpper', toPubkeyBase58(t.keyTickArrayUpper),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1)
    ) AS "payload"
FROM ixsIncreaseLiquidity t;

CREATE OR REPLACE VIEW vwJsonIxsInitializeConfig AS
SELECT
    t.txid,
    t.order,
    "initializeConfig" AS "ix",
    JSON_OBJECT(
        'dataDefaultProtocolFeeRate', t.dataDefaultProtocolFeeRate,
        'dataFeeAuthority', toPubkeyBase58(t.dataFeeAuthority),
        'dataCollectProtocolFeesAuthority', toPubkeyBase58(t.dataCollectProtocolFeesAuthority),
        'dataRewardEmissionsSuperAuthority', toPubkeyBase58(t.dataRewardEmissionsSuperAuthority),
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram)
    ) AS "payload"
FROM ixsInitializeConfig t;

CREATE OR REPLACE VIEW vwJsonIxsInitializeFeeTier AS
SELECT
    t.txid,
    t.order,
    "initializeFeeTier" AS "ix",
    JSON_OBJECT(
        'dataTickSpacing', t.dataTickSpacing,
        'dataDefaultFeeRate', t.dataDefaultFeeRate,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyFeeTier', toPubkeyBase58(t.keyFeeTier),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram)
    ) AS "payload"
FROM ixsInitializeFeeTier t;

CREATE OR REPLACE VIEW vwJsonIxsInitializePool AS
SELECT
    t.txid,
    t.order,
    "initializePool" AS "ix",
    JSON_OBJECT(
        'dataTickSpacing', t.dataTickSpacing,
        'dataInitialSqrtPrice', toU128String(t.dataInitialSqrtPrice),
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyTokenMintA', toPubkeyBase58(t.keyTokenMintA),
        'keyTokenMintB', toPubkeyBase58(t.keyTokenMintB),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenVaultA', toPubkeyBase58(t.keyTokenVaultA),
        'keyTokenVaultB', toPubkeyBase58(t.keyTokenVaultB),
        'keyFeeTier', toPubkeyBase58(t.keyFeeTier),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent)
    ) AS "payload"
FROM ixsInitializePool t;

CREATE OR REPLACE VIEW vwJsonIxsInitializePositionBundle AS
SELECT
    t.txid,
    t.order,
    "initializePositionBundle" AS "ix",
    JSON_OBJECT(
        'keyPositionBundle', toPubkeyBase58(t.keyPositionBundle),
        'keyPositionBundleMint', toPubkeyBase58(t.keyPositionBundleMint),
        'keyPositionBundleTokenAccount', toPubkeyBase58(t.keyPositionBundleTokenAccount),
        'keyPositionBundleOwner', toPubkeyBase58(t.keyPositionBundleOwner),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent),
        'keyAssociatedTokenProgram', toPubkeyBase58(t.keyAssociatedTokenProgram)
    ) AS "payload"
FROM ixsInitializePositionBundle t;

CREATE OR REPLACE VIEW vwJsonIxsInitializePositionBundleWithMetadata AS
SELECT
    t.txid,
    t.order,
    "initializePositionBundleWithMetadata" AS "ix",
    JSON_OBJECT(
        'keyPositionBundle', toPubkeyBase58(t.keyPositionBundle),
        'keyPositionBundleMint', toPubkeyBase58(t.keyPositionBundleMint),
        'keyPositionBundleMetadata', toPubkeyBase58(t.keyPositionBundleMetadata),
        'keyPositionBundleTokenAccount', toPubkeyBase58(t.keyPositionBundleTokenAccount),
        'keyPositionBundleOwner', toPubkeyBase58(t.keyPositionBundleOwner),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyMetadataUpdateAuth', toPubkeyBase58(t.keyMetadataUpdateAuth),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent),
        'keyAssociatedTokenProgram', toPubkeyBase58(t.keyAssociatedTokenProgram),
        'keyMetadataProgram', toPubkeyBase58(t.keyMetadataProgram)
    ) AS "payload"
FROM ixsInitializePositionBundleWithMetadata t;

CREATE OR REPLACE VIEW vwJsonIxsInitializeReward AS
SELECT
    t.txid,
    t.order,
    "initializeReward" AS "ix",
    JSON_OBJECT(
        'dataRewardIndex', t.dataRewardIndex,
        'keyRewardAuthority', toPubkeyBase58(t.keyRewardAuthority),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyRewardMint', toPubkeyBase58(t.keyRewardMint),
        'keyRewardVault', toPubkeyBase58(t.keyRewardVault),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent)
    ) AS "payload"
FROM ixsInitializeReward t;

CREATE OR REPLACE VIEW vwJsonIxsInitializeTickArray AS
SELECT
    t.txid,
    t.order,
    "initializeTickArray" AS "ix",
    JSON_OBJECT(
        'dataStartTickIndex', t.dataStartTickIndex,
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyTickArray', toPubkeyBase58(t.keyTickArray),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram)
    ) AS "payload"
FROM ixsInitializeTickArray t;

CREATE OR REPLACE VIEW vwJsonIxsOpenBundledPosition AS
SELECT
    t.txid,
    t.order,
    "openBundledPosition" AS "ix",
    JSON_OBJECT(
        'dataBundleIndex', t.dataBundleIndex,
        'dataTickLowerIndex', t.dataTickLowerIndex,
        'dataTickUpperIndex', t.dataTickUpperIndex,
        'keyBundledPosition', toPubkeyBase58(t.keyBundledPosition),
        'keyPositionBundle', toPubkeyBase58(t.keyPositionBundle),
        'keyPositionBundleTokenAccount', toPubkeyBase58(t.keyPositionBundleTokenAccount),
        'keyPositionBundleAuthority', toPubkeyBase58(t.keyPositionBundleAuthority),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent)
    ) AS "payload"
FROM ixsOpenBundledPosition t;

CREATE OR REPLACE VIEW vwJsonIxsOpenPosition AS
SELECT
    t.txid,
    t.order,
    "openPosition" AS "ix",
    JSON_OBJECT(
        'dataTickLowerIndex', t.dataTickLowerIndex,
        'dataTickUpperIndex', t.dataTickUpperIndex,
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyOwner', toPubkeyBase58(t.keyOwner),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionMint', toPubkeyBase58(t.keyPositionMint),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent),
        'keyAssociatedTokenProgram', toPubkeyBase58(t.keyAssociatedTokenProgram)
    ) AS "payload"
FROM ixsOpenPosition t;

CREATE OR REPLACE VIEW vwJsonIxsOpenPositionWithMetadata AS
SELECT
    t.txid,
    t.order,
    "openPositionWithMetadata" AS "ix",
    JSON_OBJECT(
        'dataTickLowerIndex', t.dataTickLowerIndex,
        'dataTickUpperIndex', t.dataTickUpperIndex,
        'keyFunder', toPubkeyBase58(t.keyFunder),
        'keyOwner', toPubkeyBase58(t.keyOwner),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyPositionMint', toPubkeyBase58(t.keyPositionMint),
        'keyPositionMetadataAccount', toPubkeyBase58(t.keyPositionMetadataAccount),
        'keyPositionTokenAccount', toPubkeyBase58(t.keyPositionTokenAccount),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keySystemProgram', toPubkeyBase58(t.keySystemProgram),
        'keyRent', toPubkeyBase58(t.keyRent),
        'keyAssociatedTokenProgram', toPubkeyBase58(t.keyAssociatedTokenProgram),
        'keyMetadataProgram', toPubkeyBase58(t.keyMetadataProgram),
        'keyMetadataUpdateAuth', toPubkeyBase58(t.keyMetadataUpdateAuth)
    ) AS "payload"
FROM ixsOpenPositionWithMetadata t;

CREATE OR REPLACE VIEW vwJsonIxsSetCollectProtocolFeesAuthority AS
SELECT
    t.txid,
    t.order,
    "setCollectProtocolFeesAuthority" AS "ix",
    JSON_OBJECT(
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyCollectProtocolFeesAuthority', toPubkeyBase58(t.keyCollectProtocolFeesAuthority),
        'keyNewCollectProtocolFeesAuthority', toPubkeyBase58(t.keyNewCollectProtocolFeesAuthority)
    ) AS "payload"
FROM ixsSetCollectProtocolFeesAuthority t;

CREATE OR REPLACE VIEW vwJsonIxsSetDefaultFeeRate AS
SELECT
    t.txid,
    t.order,
    "setDefaultFeeRate" AS "ix",
    JSON_OBJECT(
        'dataDefaultFeeRate', t.dataDefaultFeeRate,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyFeeTier', toPubkeyBase58(t.keyFeeTier),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority)
    ) AS "payload"
FROM ixsSetDefaultFeeRate t;

CREATE OR REPLACE VIEW vwJsonIxsSetDefaultProtocolFeeRate AS
SELECT
    t.txid,
    t.order,
    "setDefaultProtocolFeeRate" AS "ix",
    JSON_OBJECT(
        'dataDefaultProtocolFeeRate', t.dataDefaultProtocolFeeRate,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority)
    ) AS "payload"
FROM ixsSetDefaultProtocolFeeRate t;

CREATE OR REPLACE VIEW vwJsonIxsSetFeeAuthority AS
SELECT
    t.txid,
    t.order,
    "setFeeAuthority" AS "ix",
    JSON_OBJECT(
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority),
        'keyNewFeeAuthority', toPubkeyBase58(t.keyNewFeeAuthority)
    ) AS "payload"
FROM ixsSetFeeAuthority t;

CREATE OR REPLACE VIEW vwJsonIxsSetFeeRate AS
SELECT
    t.txid,
    t.order,
    "setFeeRate" AS "ix",
    JSON_OBJECT(
        'dataFeeRate', t.dataFeeRate,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority)
    ) AS "payload"
FROM ixsSetFeeRate t;

CREATE OR REPLACE VIEW vwJsonIxsSetProtocolFeeRate AS
SELECT
    t.txid,
    t.order,
    "setProtocolFeeRate" AS "ix",
    JSON_OBJECT(
        'dataProtocolFeeRate', t.dataProtocolFeeRate,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyFeeAuthority', toPubkeyBase58(t.keyFeeAuthority)
    ) AS "payload"
FROM ixsSetProtocolFeeRate t;

CREATE OR REPLACE VIEW vwJsonIxsSetRewardAuthority AS
SELECT
    t.txid,
    t.order,
    "setRewardAuthority" AS "ix",
    JSON_OBJECT(
        'dataRewardIndex', t.dataRewardIndex,
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyRewardAuthority', toPubkeyBase58(t.keyRewardAuthority),
        'keyNewRewardAuthority', toPubkeyBase58(t.keyNewRewardAuthority)
    ) AS "payload"
FROM ixsSetRewardAuthority t;

CREATE OR REPLACE VIEW vwJsonIxsSetRewardAuthorityBySuperAuthority AS
SELECT
    t.txid,
    t.order,
    "setRewardAuthorityBySuperAuthority" AS "ix",
    JSON_OBJECT(
        'dataRewardIndex', t.dataRewardIndex,
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyRewardEmissionsSuperAuthority', toPubkeyBase58(t.keyRewardEmissionsSuperAuthority),
        'keyNewRewardAuthority', toPubkeyBase58(t.keyNewRewardAuthority)
    ) AS "payload"
FROM ixsSetRewardAuthorityBySuperAuthority t;

CREATE OR REPLACE VIEW vwJsonIxsSetRewardEmissions AS
SELECT
    t.txid,
    t.order,
    "setRewardEmissions" AS "ix",
    JSON_OBJECT(
        'dataRewardIndex', t.dataRewardIndex,
        'dataEmissionsPerSecondX64', toU128String(t.dataEmissionsPerSecondX64),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyRewardAuthority', toPubkeyBase58(t.keyRewardAuthority),
        'keyRewardVault', toPubkeyBase58(t.keyRewardVault)
    ) AS "payload"
FROM ixsSetRewardEmissions t;

CREATE OR REPLACE VIEW vwJsonIxsSetRewardEmissionsSuperAuthority AS
SELECT
    t.txid,
    t.order,
    "setRewardEmissionsSuperAuthority" AS "ix",
    JSON_OBJECT(
        'keyWhirlpoolsConfig', toPubkeyBase58(t.keyWhirlpoolsConfig),
        'keyRewardEmissionsSuperAuthority', toPubkeyBase58(t.keyRewardEmissionsSuperAuthority),
        'keyNewRewardEmissionsSuperAuthority', toPubkeyBase58(t.keyNewRewardEmissionsSuperAuthority)
    ) AS "payload"
FROM ixsSetRewardEmissionsSuperAuthority t;

CREATE OR REPLACE VIEW vwJsonIxsSwap AS
SELECT
    t.txid,
    t.order,
    "swap" AS "ix",
    JSON_OBJECT(
        'dataAmount', toU64String(t.dataAmount),
        'dataOtherAmountThreshold', toU64String(t.dataOtherAmountThreshold),
        'dataSqrtPriceLimit', toU128String(t.dataSqrtPriceLimit),
        'dataAmountSpecifiedIsInput', t.dataAmountSpecifiedIsInput,
        'dataAToB', t.dataAToB,
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keyTokenAuthority', toPubkeyBase58(t.keyTokenAuthority),
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyTokenOwnerAccountA', toPubkeyBase58(t.keyTokenOwnerAccountA),
        'keyVaultA', toPubkeyBase58(t.keyVaultA),
        'keyTokenOwnerAccountB', toPubkeyBase58(t.keyTokenOwnerAccountB),
        'keyVaultB', toPubkeyBase58(t.keyVaultB),
        'keyTickArray0', toPubkeyBase58(t.keyTickArray0),
        'keyTickArray1', toPubkeyBase58(t.keyTickArray1),
        'keyTickArray2', toPubkeyBase58(t.keyTickArray2),
        'keyOracle', toPubkeyBase58(t.keyOracle),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1)
    ) AS "payload"
FROM ixsSwap t;

CREATE OR REPLACE VIEW vwJsonIxsTwoHopSwap AS
SELECT
    t.txid,
    t.order,
    "twoHopSwap" AS "ix",
    JSON_OBJECT(
        'dataAmount', toU64String(t.dataAmount),
        'dataOtherAmountThreshold', toU64String(t.dataOtherAmountThreshold),
        'dataAmountSpecifiedIsInput', t.dataAmountSpecifiedIsInput,
        'dataAToBOne', t.dataAToBOne,
        'dataAToBTwo', t.dataAToBTwo,
        'dataSqrtPriceLimitOne', toU128String(t.dataSqrtPriceLimitOne),
        'dataSqrtPriceLimitTwo', toU128String(t.dataSqrtPriceLimitTwo),
        'keyTokenProgram', toPubkeyBase58(t.keyTokenProgram),
        'keyTokenAuthority', toPubkeyBase58(t.keyTokenAuthority),
        'keyWhirlpoolOne', toPubkeyBase58(t.keyWhirlpoolOne),
        'keyWhirlpoolTwo', toPubkeyBase58(t.keyWhirlpoolTwo),
        'keyTokenOwnerAccountOneA', toPubkeyBase58(t.keyTokenOwnerAccountOneA),
        'keyVaultOneA', toPubkeyBase58(t.keyVaultOneA),
        'keyTokenOwnerAccountOneB', toPubkeyBase58(t.keyTokenOwnerAccountOneB),
        'keyVaultOneB', toPubkeyBase58(t.keyVaultOneB),
        'keyTokenOwnerAccountTwoA', toPubkeyBase58(t.keyTokenOwnerAccountTwoA),
        'keyVaultTwoA', toPubkeyBase58(t.keyVaultTwoA),
        'keyTokenOwnerAccountTwoB', toPubkeyBase58(t.keyTokenOwnerAccountTwoB),
        'keyVaultTwoB', toPubkeyBase58(t.keyVaultTwoB),
        'keyTickArrayOne0', toPubkeyBase58(t.keyTickArrayOne0),
        'keyTickArrayOne1', toPubkeyBase58(t.keyTickArrayOne1),
        'keyTickArrayOne2', toPubkeyBase58(t.keyTickArrayOne2),
        'keyTickArrayTwo0', toPubkeyBase58(t.keyTickArrayTwo0),
        'keyTickArrayTwo1', toPubkeyBase58(t.keyTickArrayTwo1),
        'keyTickArrayTwo2', toPubkeyBase58(t.keyTickArrayTwo2),
        'keyOracleOne', toPubkeyBase58(t.keyOracleOne),
        'keyOracleTwo', toPubkeyBase58(t.keyOracleTwo),
        'transferAmount0', toU64String(t.transferAmount0),
        'transferAmount1', toU64String(t.transferAmount1),
        'transferAmount2', toU64String(t.transferAmount2),
        'transferAmount3', toU64String(t.transferAmount3)
    ) AS "payload"
FROM ixsTwoHopSwap t;

CREATE OR REPLACE VIEW vwJsonIxsUpdateFeesAndRewards AS
SELECT
    t.txid,
    t.order,
    "updateFeesAndRewards" AS "ix",
    JSON_OBJECT(
        'keyWhirlpool', toPubkeyBase58(t.keyWhirlpool),
        'keyPosition', toPubkeyBase58(t.keyPosition),
        'keyTickArrayLower', toPubkeyBase58(t.keyTickArrayLower),
        'keyTickArrayUpper', toPubkeyBase58(t.keyTickArrayUpper)
    ) AS "payload"
FROM ixsUpdateFeesAndRewards t;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
