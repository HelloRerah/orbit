-- CreateTable
CREATE TABLE "rentals" (
    "id" UUID NOT NULL,
    "orderId" UUID NOT NULL,
    "credentialsEncrypted" TEXT NOT NULL,
    "startsAt" TIMESTAMPTZ(3) NOT NULL,
    "endsAt" TIMESTAMPTZ(3) NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rentals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "licenses" (
    "id" UUID NOT NULL,
    "orderId" UUID NOT NULL,
    "licenseKeyEncrypted" TEXT NOT NULL,
    "issuedAt" TIMESTAMPTZ(3) NOT NULL,
    "expiresAt" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "licenses_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "rentals_orderId_key" ON "rentals"("orderId");

-- CreateIndex
CREATE INDEX "rentals_endsAt_idx" ON "rentals"("endsAt");

-- CreateIndex
CREATE UNIQUE INDEX "licenses_orderId_key" ON "licenses"("orderId");

-- AddForeignKey
ALTER TABLE "rentals" ADD CONSTRAINT "rentals_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "licenses" ADD CONSTRAINT "licenses_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
