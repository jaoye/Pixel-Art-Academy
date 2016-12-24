AB = Artificial.Babel
AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions
RA = Retronator.Accounts
RS = Retronator.Store
HQ = Retronator.HQ

class HQ.Items.Tablet.Apps.ShoppingCart.Receipt extends HQ.Items.Tablet.Apps.Components.Stripe
  @register 'Retronator.HQ.Items.Tablet.Apps.ShoppingCart.Receipt'

  constructor: (@options) ->
    super

  onCreated: ->
    super

    # Get all store items data.
    @subscribe RS.Transactions.Item.all

    # Get top recent transactions to display the supporters list.
    @subscribe RS.Transactions.Transaction.topRecent

    # Get store balance and credit so we know if credit can be applied (and the user charged less).
    @subscribe RA.User.storeDataForCurrentUser
    
    # Get user's contact email so we can pre-fill it in Stripe Checkout.
    @subscribe RA.User.contactEmailForCurrentUser

    @_userBabelSubscription = AB.subscribeNamespace 'Retronator.Accounts.User'

  onRendered: ->
    super

    $('.retronator-hq-items-tablet').addClass('receipt-visible')

    @_scrollToNewSupporter()

  onDestroyed: ->
    super

    $('.retronator-hq-items-tablet').removeClass('receipt-visible')

  state: ->
    @options.shoppingCart.state()

  showSupporterName: ->
    user = Retronator.user()

    if user then user.profile?.showSupporterName else @state().showSupporterName

  supporterName: ->
    return unless @showSupporterName()

    user = Retronator.user()

    if user then user.profile.supporterName else @state().supporterName
  
  anonymousPlaceholder: ->
    AB.translate(@_userBabelSubscription, 'Anonymous').text
    
  anonymousCheckboxAttributes: ->
    checked: true unless @showSupporterName()

  purchaseItems: ->
    for receiptItem in @state().contents
      item = RS.Transactions.Item.documents.findOne catalogKey: receiptItem.item
      continue unless item

      item: item
      isGift: receiptItem.isGift
    
  itemsPrice: ->
    # The sum of all items to be purchased.
    _.sum (storeItem.item.price for storeItem in @purchaseItems())

  totalPrice: ->
    # Total is the items price with added tip.
    @itemsPrice() + (@state().tip.amount or 0)

  creditApplied: ->
    storeCredit = Retronator.user()?.store?.credit or 0

    # Credit is applied up to the amount in the shopping cart.
    Math.min storeCredit, @totalPrice()

  paymentAmount: ->
    # See how much the user will need to pay to complete this transaction, after the credit is applied.
    storeCredit = Retronator.user()?.store?.credit or 0

    # Existing store credit decreases the needed amount to pay, but of course not below zero.
    Math.max 0, @totalPrice() - storeCredit

  topRecentTransactions: ->
    # First get the existing top 10.
    recentTransactions = RS.Components.TopSupporters.topRecentTransactions.find({},
      sort: [
        ['amount', 'desc']
        ['time', 'desc']
      ]
    ).fetch()

    # Mark as existing transactions.
    transaction.existing = true for transaction in recentTransactions

    # Create new transaction.
    newTransaction =
      name: @supporterName()
      amount: @totalPrice()
      new: true

    newTransaction.message = @state().tip.message if @state().tip.amount

    # Find where the new transaction needs to be inserted. We use
    # a negative amount because the list is in descending order.
    insertIndex = _.sortedIndexBy recentTransactions, newTransaction, (transaction) -> -transaction.amount

    # Add the new transaction and return the result.
    recentTransactions.splice insertIndex, 0, newTransaction
    recentTransactions

  tip: ->
    @state().tip

  supporterName: ->
    @state().supporterName

  events: ->
    super.concat
      'change .anonymous-checkbox': @onChangeAnonymousCheckbox
      'input .supporter-name': @onInputSupporterName
      'input .tip-amount': @onInputTipAmount
      'input .tip-message': @onInputTipMessage
      'click .submit-payment-button': @onClickSubmitPaymentButton

  onChangeAnonymousCheckbox: (event) ->
    if Meteor.userId()
      Meteor.call "Retronator.Accounts.User.setShowSupporterName", not event.target.checked

    else
      @state().showSupporterName = not event.target.checked
      @options.adventure.gameState.updated()

  onInputSupporterName: (event) ->
    name = $(event.target).val()
    @state().supporterName = name
    @options.adventure.gameState.updated()

  onInputTipAmount: (event) ->
    enteredString = $(event.target).val()

    # Make sure the entered value is a number.
    try
      enteredValue = parseFloat enteredString

    catch
      enteredValue = 0

    # If negative sign is entered the parsing succeeds with a NaN value.
    enteredValue = 0 if _.isNaN enteredValue

    # Constrain to non-negative numbers and round to dollar amount.
    value = Math.floor Math.max 0, enteredValue

    # Rewrite the value in the input if needed.
    newString = "#{value}"
    $(event.target).val newString unless newString is enteredString

    @state().tip.amount = value
    @options.adventure.gameState.updated()

    @_scrollToNewSupporter()

  _scrollToNewSupporter: ->
    Tracker.afterFlush =>
      $('.retronator-store-components-top-supporters .new.supporter').velocity('stop').velocity 'scroll',
        duration: 200
        container: $('.retronator-hq-locations-checkout-display .screen')

  onInputTipMessage: (event) ->
    message = $(event.target).val()
    @state().tip.message = message
    @options.adventure.gameState.updated()
