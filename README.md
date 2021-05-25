# README

**Deployed Version:** https://fierce-shore-55169.herokuapp.com/

## Application Summary

This is a functional clone of Wealthsimple, the popular Canadian robo-advisor application, I built with Ruby on Rails. Wealthsimple is one of the applications that inspired me to learn web development in the first place. Consequently, it was loads of fun to clone.

With this clone application, you can:

- Create a password-protected account (authentication handled through Devise)
- Set your risk tolerance
- Create a mock investment account (i.e. Roth IRA, 401k, RRSP, TFSA, etc)
- Make mock deposits (which will be invested automatically based on your risk tolerance, just like with the real application)
- Make mock withdrawals
- Monitor the balance of your individual accounts and your entire holdings within the app

The core technologies behind this application are as follows.

**Back-End:**

- Rails 6.1.3.2
- Ruby 3.0.1
- PostgreSQL
- RSpec

**Front-End**

- Bulma
- Chartkick

Keep reading for a walkthrough of the application and how its various parts come together. I encourage you to follow along using the deployed app (see link above). It's pretty cool!

## Splash Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-homepage.png">

The splash page uses the same looping video from Wealthsimple's website.

## Signup Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-signup.png">

When you click the "Get started" button on the Splash Page, you'll land here. This is the Devise/Registrations/New view. I tweaked/added two fields to the User model (and subsequently this form) to better mirror the real Wealthsimple's functionality. Those are:

- Name, which isn't new but is now a mandatory field (it's optional by default with Devise). This is essential for the personalized messages I've placed throughout the app.
- Risk Tolerance, which is a completely new field. This is essential for the application's core functionality as a robo-advisor. A portfolio will automatically be created for the user based on their risk tolerance.

## Sign-in Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-login.png">

Once you create your account, you'll be redirected here and asked to log in.

## Profile Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-empty-profile.png">

Once you've logged in, you'll land on your profile page. If you're a new user, the page will be virtually empty. That's because you haven't created an investment Account yet!

## New Account Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-new-account-page.png">

Once you click the "Open an account" button on the previous page, you'll land here. All you need to do is give your account a nickname.

**Once you've done that and hit "Create account," a Holding record will automatically be assigned to the resulting Account based on your risk tolerance.** This is identical to how the real Wealthsimple works. The Holding model functions as your portfolio's allocation. Any mock deposits you make will be invested based on this record, which gets created alongside the Account here.

**Note:** The Holding record relies on another model, Asset. In the deployed version of this app, I've seeded the database with five Assets. Their riskiness ranges from 1 to 5 and corresponds directly with the User's risk tolerance.

It works like this:

1. A new Account is created
2. Logic in the Account model goes looking for an Asset with a riskiness matching the User's risk tolerance
3. The Holding record is created and attached to the Account

## Empty Account Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-empty-account.png">

Once you've created your account, you'll be redirected to this page, which shows your account summary. As with the new profile page, there won't be much to look at until you start making mock transactions, which you can do by clicking on the "Fund this account" button.

**Note:** Under the "Invested in" section of the top bar, you can see the portfolio that's been selected for your account (again, based on your risk tolerance).

## New Transaction Page

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-new-transaction-page.png">

Here, you can choose which account you'd like to interact with, what type of transaction you're making, and how much money it will involve.

The assumption when you're making a **deposit** is that it will come from some external bank account. When you make a withdrawal, however, you will be limited to mock funds within your account. In other words, validations prevent you withdrawing more money from the mock app than you actually have in it.

Here's what that looks like:

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-withdrawal-error.png">

## Account Page with First Transaction

Once you make your first deposit, information starts filling in on the Account page.

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-first-deposit.png">

Most prominent is the yellow area chart up top. The horizontal axis represents time while the vertical axis represents your account's balance. This chart is created using Chartkick and Google Charts.

You'll also see your deposit has prompted two items in the "Transactions" box. The first is the deposit itself, followed by the mock investment of that money. This is exactly how the real Wealthsimple works (although it would take a business day or two for a deposit to result in an accompanying investment; I've sped the process up).

Lastly, you'll see the "Deposit insights" box. As you make deposits throughout the day (real-time in UTC), you'll see them reflected in that day's chart column. When a new day begins (again, real-time) and you make a new deposit then, a new column will appear beside this one. With this section, you can see how your deposit amounts have varied from day-to-day. The real Wealthsimple spreads this data out monthly. I've made it daily to be more user-friendly for the purposes of this test app.

If you scroll down on this page, you'll also see the "Portfolio" box has been populated with data. 

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-first-deposit-02.png">

This happens through the Holding and Account models. 

The "Cash" item is populated through the Account's available balance column. Now, because deposits are automatically invested, this will most likely always be zero based on the assets I've seeded the database with. They're all priced at $1 per unit, which means even an odd account balance (i.e. $3,333) can be invested. However, if an asset were priced at $2 and the account's balance was $3,333, the app would simply invest as much as it could and then leave the rest in "Cash." This relies on the modulo operator.

## Account Page with Many Transactions

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-many-deposits.png">

As you keep making transactions, the historical balance graph will adjust accordingly, as will all other non-static elements on the page (i.e. the "Transactions" and "Deposit insights" boxes).

**Note:** To track historical balances like this, I've used the <a href="https://github.com/paper-trail-gem/paper_trail">Paper Trail</a> gem. It tracks each account's balance before and after transactions are made. This is how it plots an account's history even though only its current state is reflected in the account's record itself.

## Profile Page with Accounts and Transactions

<img src="https://github.com/brandonricharda/wealthsimple-clone/blob/main/app/assets/images/wealthsimple-clone-profile-page-many-transactions.png">

Lastly, if you return to the Profile Page, you'll see it's now filled out with lots of information. There's the big balance tracker at the top of the page. Underneath it is an area chart showcasing how the user's total balance (across all accounts) has changed over time.

**Note:** The User's historical balance graph uses the Paper Trail gem as well. The app iterates through all of the User's investment accounts and grabs a snapshot of their balances at various points. It uses that data to create the chart.

## Thanks for Checking This Out!

As I mentioned earlier, I had so much fun building this Wealthsimple clone. The process really reinforced for me that no problem is impossible to solve if you're willing to think about it creatively and do the research.
