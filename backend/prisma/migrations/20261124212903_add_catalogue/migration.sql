-- CreateEnum
CREATE TYPE "ProductType" AS ENUM ('RENTAL', 'LICENSE');

-- CreateTable
CREATE TABLE "products" (
    "id" UUID NOT NULL,
    "halabServiceId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT,
    "description" TEXT,
    "type" "ProductType" NOT NULL,
    "costUsd" DECIMAL(12,4) NOT NULL,
    "isVisible" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastSyncedAt" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settings" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "exchangeRateUsdZar" DECIMAL(10,4) NOT NULL,
    "markupPercent" DECIMAL(5,2) NOT NULL,
    "priceRoundingZar" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "lowBalanceThresholdUsd" DECIMAL(12,2) NOT NULL,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "settings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "products_halabServiceId_key" ON "products"("halabServiceId");
