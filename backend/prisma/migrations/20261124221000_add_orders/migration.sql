-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING_PAYMENT', 'PAID', 'SUBMITTED', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED');

-- CreateTable
CREATE TABLE "orders" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "type" "ProductType" NOT NULL,
    "sessionHours" SMALLINT,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING_PAYMENT',
    "productNameSnapshot" TEXT NOT NULL,
    "priceZar" DECIMAL(10,2) NOT NULL,
    "costUsd" DECIMAL(12,4) NOT NULL,
    "exchangeRateUsdZar" DECIMAL(10,4) NOT NULL,
    "markupPercent" DECIMAL(5,2) NOT NULL,
    "vatRate" DECIMAL(5,2),
    "vatAmountZar" DECIMAL(10,2),
    "deviceInfo" JSONB,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "orders_userId_createdAt_idx" ON "orders"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "orders_status_idx" ON "orders"("status");

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_productId_fkey" FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
