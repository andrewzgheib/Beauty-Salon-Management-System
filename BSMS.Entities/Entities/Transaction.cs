﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("transactions")]
public partial class Transaction
{
    [Key]
    [Column("transaction_id")]
    public int TransactionId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("transaction_type_id")]
    public int TransactionTypeId { get; set; }

    [Column("transaction_charge", TypeName = "money")]
    public decimal TransactionCharge { get; set; }

    [Column("transaction_time", TypeName = "timestamp without time zone")]
    public DateTime TransactionTime { get; set; }

    [Column("transaction_status", TypeName = "citext")]
    public string TransactionStatus { get; set; } = null!;

    [Column("is_deposit")]
    public bool IsDeposit { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("Transactions")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("TransactionTypeId")]
    [InverseProperty("Transactions")]
    public virtual TransactionType TransactionType { get; set; } = null!;
}
