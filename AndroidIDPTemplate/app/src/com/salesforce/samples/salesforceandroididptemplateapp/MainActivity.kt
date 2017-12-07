/*
 * Copyright (c) 2017-present, salesforce.com, inc.
 * All rights reserved.
 * Redistribution and use of this software in source and binary forms, with or
 * without modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * - Neither the name of salesforce.com, inc. nor the names of its contributors
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission of salesforce.com, inc.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package com.salesforce.samples.salesforceandroididptemplateapp

import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.TabHost
import com.salesforce.androidsdk.accounts.UserAccount
import com.salesforce.androidsdk.accounts.UserAccountManager
import com.salesforce.androidsdk.rest.RestClient
import com.salesforce.androidsdk.ui.SalesforceActivity

/**
 * This activity represents the landing screen. It displays 2 tabs - 1 for apps
 * and the other for signed in users. It can be used to add users or launch
 * SP apps with the specified user to trigger login on the SP app.
 *
 * @author bhariharan
 */
class MainActivity : SalesforceActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val USERS_TAB = "Users"
        private const val APPS_TAB = "Apps"
        private const val SMART_SYNC_EXPLORER = "SmartSyncExplorer"
        private const val REST_EXPLORER = "RestExplorer"
        private const val ACCOUNT_EDITOR = "AccountEditor"
    }

    private var client: RestClient? = null
    private var usersListView: ListView? = null
    private var appsListView: ListView? = null
    private var currentUser: UserAccount? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main)
        val tabHost = findViewById<TabHost>(R.id.tab_host)
        tabHost.setup()

        // Tab that displays list of users.
        val usersTabSpec: TabHost.TabSpec = tabHost.newTabSpec(USERS_TAB)
        usersTabSpec.setContent(R.id.users_tab)
        usersTabSpec.setIndicator(USERS_TAB)
        tabHost.addTab(usersTabSpec)

        // Tab that displays list of apps.
        val appsTabSpec = tabHost.newTabSpec(APPS_TAB)
        appsTabSpec.setContent(R.id.apps_tab)
        appsTabSpec.setIndicator(APPS_TAB)
        tabHost.addTab(appsTabSpec)

        // Getting a handle on list views.
        usersListView = findViewById<ListView>(R.id.users_list)
        appsListView = findViewById<ListView>(R.id.apps_list)

        // Setting click listeners for the list views.

    }

    override fun onResume() {
        findViewById<ViewGroup>(R.id.root).visibility = View.INVISIBLE
        super.onResume()
    }

    override fun onResume(client: RestClient) {
        this.client = client
        currentUser = UserAccountManager.getInstance().currentUser
        findViewById<ViewGroup>(R.id.root).visibility = View.VISIBLE

        // Displays list of users available.
        val users = UserAccountManager.getInstance().authenticatedUsers
        usersListView?.adapter = ArrayAdapter(this,
                android.R.layout.simple_selectable_list_item, buildListOfUsers())

        // Displays list of apps available.
        appsListView?.adapter = ArrayAdapter(this, android.R.layout.simple_selectable_list_item,
                arrayListOf(SMART_SYNC_EXPLORER, REST_EXPLORER, ACCOUNT_EDITOR))
    }

    private fun buildListOfUsers(): List<String>? {
        val users = UserAccountManager.getInstance().authenticatedUsers
        val usernames: MutableList<String> = mutableListOf()
        if (users != null) {
            for (user in users) {
                usernames.add(user.username)
            }
        }
        return usernames
    }
}
